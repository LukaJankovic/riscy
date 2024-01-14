VIVADO_SETTINGS := C:/Xilinx/Vivado/2023.2/settings64.sh

PROJ_NAME		:= example
SIM_TOP			:= example_tb
TOP				:= and_gate

SRC_DIR			:= src
SIM_DIR			:= sim
BUILD_DIR		:= .build

WAVEFORM_CFG := $(SIM_DIR)/$(SIM_TOP).sim.wcfg

WAVEFORM_VCD := simulation_${PROJ_NAME}.wdb

PART		:= xc7z020clg400-1
CONSTRAINTS	:= Zybo-Z7.xdc

THREADS		:= 16

all: sim

sim: $(WAVEFORM_VCD)

$(WAVEFORM_VCD): $(SRC_DIR)/*.vhdl
	source $(VIVADO_SETTINGS) && \
	cd $(BUILD_DIR) && \
	xelab -debug typical -top $(SIM_TOP) -snapshot $(SIM_TOP)_snapshot && \
	xsim $(SIM_TOP)_snapshot -gui -view ../$(WAVEFORM_CFG)

$(SRC_DIR)/*.vhdl: $(BUILD_DIR) 
	source $(VIVADO_SETTINGS) && \
	cd $(BUILD_DIR) && \
	xvhdl ../$(SRC_DIR)/*.vhdl ../$(SIM_DIR)/*.vhdl

$(BUILD_DIR):
	source $(VIVADO_SETTINGS) && \
	mkdir -p $@

build: $(BUILD_DIR)/build.tcl
	source $(VIVADO_SETTINGS) && \
	cd .build && \
	vivado -mode batch -nojournal -source build.tcl

program: $(BUILD_DIR)/program.tcl
	source $(VIVADO_SETTINGS) && \
	cd .build && \
	vivado -mode batch -nojournal -source program.tcl

$(BUILD_DIR)/build.tcl: build.tcl.in $(BUILD_DIR)
	sed -e 's/{{THREADS}}/$(THREADS)/g' \
		-e 's/{{CONST}}/$(CONSTRAINTS)/g' \
		-e 's/{{PART}}/$(PART)/g' \
		-e 's/{{TOP}}/$(TOP)/g' \
		-e 's/{{PROJ}}/$(PROJ_NAME)/g' \
		-e 's/{{SRC}}/$(SRC_DIR)/g' $< > $@

$(BUILD_DIR)/program.tcl: program.tcl.in $(BUILD_DIR)
	sed -e 's/{{PROJ}}/$(PROJ_NAME)/g' $< > $@

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) *.log *.pb *.jou *.wdb *.str xsim.dir .Xil