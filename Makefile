VIVADO_PATH := C:/Xilinx/Vivado/2024.1

VIVADO_SETTINGS_WIN := $(VIVADO_PATH)/settings64.bat
VIVADO_SETTINGS_LIN := $(VIVADO_PATH)/settings64.sh

PROJ_NAME		:= riscy
SIM_TOP			:= riscy_tb
TOP				:= riscy_top

SRC_DIR			:= src
SIM_DIR			:= sim
BUILD_DIR		:= .build

WAVEFORM_CFG := $(SIM_DIR)/$(SIM_TOP).sim.wcfg

WAVEFORM_VCD := simulation_${PROJ_NAME}.wdb

PART		:= xc7z020clg400-1
CONSTRAINTS	:= Zybo-Z7.xdc

THREADS		:= 16

ifeq ($(OS),Windows_NT)
	MKDIR=mkdir
	SOURCE=$(VIVADO_SETTINGS_WIN)
	RM=del /f /q
else
	MKDIR=mkdir -p
	SOURCE=source $(VIVADO_SETTINGS_LIN)
	RM=rm -rf
endif

SRC_VHDL := $(wildcard $(SRC_DIR)/*.vhdl)
SIM_VHDL := $(wildcard $(SIM_DIR)/*.vhdl)

all: sim

sim: mem $(WAVEFORM_VCD)

mem: $(BUILD_DIR)
	cd $(BUILD_DIR) && \
	sed "s/{{MEM_FILE}}/$(MEM_FILE)/g" ../$(SRC_DIR)/imem.vhdl.in > imem.vhdl

$(WAVEFORM_VCD): $(SRC_DIR)/*.vhdl $(SIM_DIR)/*.vhdl
	$(SOURCE) && \
	cd $(BUILD_DIR) && \
	xvhdl $(addprefix ../, $(SRC_VHDL)) $(addprefix ../, $(SIM_VHDL)) imem.vhdl && \
	xelab -debug typical -top $(SIM_TOP) -snapshot $(SIM_TOP)_snapshot && \
	xsim $(SIM_TOP)_snapshot -gui -view ../$(WAVEFORM_CFG)

$(BUILD_DIR):
	mkdir -p $@

build: mem $(BUILD_DIR)/build.tcl
	$(SOURCE) && \
	cd .build && \
	vivado -mode batch -nojournal -source build.tcl

program: $(BUILD_DIR)/program.tcl
	$(SOURCE) && \
	cd .build && \
	vivado -mode batch -nojournal -source program.tcl

$(BUILD_DIR)/build.tcl: build.tcl.in $(BUILD_DIR)
	sed -e "s/{{THREADS}}/$(THREADS)/g" \
		-e "s/{{CONST}}/$(CONSTRAINTS)/g" \
		-e "s/{{PART}}/$(PART)/g" \
		-e "s/{{TOP}}/$(TOP)/g" \
		-e "s/{{PROJ}}/$(PROJ_NAME)/g" \
		-e "s/{{SRC}}/$(SRC_DIR)/g" $< > $@

$(BUILD_DIR)/program.tcl: program.tcl.in $(BUILD_DIR)
	sed -e "s/{{PROJ}}/$(PROJ_NAME)/g" $< > $@

.PHONY: clean
clean:
	$(RM) $(BUILD_DIR) $(wildcard *.log) $(wildcard *.pb) $(wildcard *.jou) $(wildcard *.wdb) $(wildcard *.str) xsim.dir .Xil