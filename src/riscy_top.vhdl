library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscy_top is
    port (
        clk : in std_logic;
        reset : in std_logic;

        ssd0 : out std_logic_vector (6 downto 0);
        ssd0_cs : out std_logic
    );
end entity riscy_top;

architecture behav of riscy_top is

    -- ifetch stage

    component ifetch is
        port (
            clk : in std_logic;
            reset : in std_logic;

            inst_addr : out std_logic_vector (31 downto 0)
        );
    end component ifetch;

    component imem is
        port (
            clk : in std_logic;

            inst_addr : in std_logic_vector (31 downto 0);
            inst_out : out std_logic_vector (31 downto 0)
        );
    end component imem;

    -- idecode stage

    component idecode is
        port (
            inst : in std_logic_vector (31 downto 0);

            opcode : out std_logic_vector (6 downto 0);

            rd : out std_logic_vector (4 downto 0);
            rs1 : out std_logic_vector (4 downto 0);
            rs2 : out std_logic_vector (4 downto 0);

            shamt : out std_logic_vector (4 downto 0);

            funct3 : out std_logic_vector (2 downto 0);
            funct7 : out std_logic_vector (6 downto 0);

            immediate : out std_logic_vector (31 downto 0)
        );
    end component idecode;

    component regs is
        port(
            clk : in std_logic;
            reset : in std_logic;

            rd : in std_logic_vector (4 downto 0);
            wdat : in std_logic_vector (31 downto 0);
            wen : in std_logic;

            rs1 : in std_logic_vector (4 downto 0);
            rs2 : in std_logic_vector (4 downto 0);

            rdat1 : out std_logic_vector (31 downto 0);
            rdat2 : out std_logic_vector (31 downto 0);

            debug_r : in std_logic_vector (4 downto 0);
            debug_dat : out std_logic_vector (31 downto 0)
        );
    end component regs;

    component control is
        port(
            funct3 : in std_logic_vector (2 downto 0);
            opcode : in std_logic_vector (6 downto 0);

            use_alt : out std_logic;
            alu_src2_mux : out std_logic_vector (0 downto 0);
            alu_op : out std_logic_vector (2 downto 0);

            dmem_op : out std_logic_vector (2 downto 0);
            dmem_wen : out std_logic;

            wb_mux : out std_logic;
            regs_wen : out std_logic
        );
    end component control;

    -- alu stage

    component alu is
        port (
            clk : in std_logic;

            opa : in std_logic_vector (31 downto 0);
            opb : in std_logic_vector (31 downto 0);

            op : in std_logic_vector (2 downto 0);
            use_alt : in std_logic;
            alt : in std_logic;

            res : out std_logic_vector (31 downto 0)
        );
    end component alu;

    -- mem stage

    component dmem is
        port (
            clk : in std_logic;
            reset : in std_logic;

            op : in std_logic_vector (2 downto 0);

            dmem_waddr : in std_logic_vector (31 downto 0);
            dmem_wdat : in std_logic_vector (31 downto 0);
            dmem_wen : in std_logic;

            dmem_raddr : in std_logic_vector (31 downto 0);

            dmem_out : out std_logic_vector (31 downto 0)
        );
    end component dmem;

    -- writeback stage

    -- others

    component pmod_ssd is
        port(
            clk : in std_logic;
            num : in std_logic_vector (7 downto 0);

            ssd : out std_logic_vector (6 downto 0);
            cs : out std_logic
        );
    end component pmod_ssd;

    signal inst_addr : std_logic_vector (31 downto 0);
    signal inst_data : std_logic_vector (31 downto 0);

    signal opcode : std_logic_vector (6 downto 0);
    signal rd : std_logic_vector (4 downto 0);
    signal rs1 : std_logic_vector (4 downto 0);
    signal rs2 : std_logic_vector (4 downto 0);
    signal shamt : std_logic_vector (4 downto 0);
    signal funct3 : std_logic_vector (2 downto 0);
    signal funct7 : std_logic_vector (6 downto 0);
    signal immediate : std_logic_vector (31 downto 0);

    signal rd_ex : std_logic_vector (4 downto 0);
    signal rd_mem : std_logic_vector (4 downto 0);
    signal rd_wb : std_logic_vector (4 downto 0);

    signal immediate_ex : std_logic_vector (31 downto 0);

    signal use_alt : std_logic;
    signal use_alt_ex : std_logic;

    signal rdat1 : std_logic_vector (31 downto 0);
    signal rdat2 : std_logic_vector (31 downto 0);

    signal rdat2_mem : std_logic_vector (31 downto 0);

    signal alu_src2_mux : std_logic_vector (0 downto 0);
    signal alu_src2_mux_ex : std_logic_vector (0 downto 0);

    signal alu_op : std_logic_vector (2 downto 0);
    signal alu_op_ex : std_logic_vector (2 downto 0);

    signal dmem_op : std_logic_vector (2 downto 0);
    signal dmem_op_ex : std_logic_vector (2 downto 0);
    signal dmem_op_mem : std_logic_vector (2 downto 0);

    signal opa : std_logic_vector (31 downto 0);
    signal opb : std_logic_vector (31 downto 0);
    signal res : std_logic_vector (31 downto 0);

    signal dmem_wen : std_logic;
    signal dmem_out : std_logic_vector (31 downto 0);

    signal dmem_wen_ex : std_logic;
    signal dmem_wen_mem : std_logic;

    signal wb_mux : std_logic;
    signal wb_mux_ex : std_logic;
    signal wb_mux_mem : std_logic;
    signal wb_mux_wb : std_logic;

    signal res_wb : std_logic_vector (31 downto 0);

    signal regs_wen : std_logic;
    signal regs_wen_ex : std_logic;
    signal regs_wen_mem : std_logic;
    signal regs_wen_wb : std_logic;

    signal regs_write : std_logic_vector (31 downto 0);

    signal debug_r : std_logic_vector (4 downto 0);
    signal debug_dat : std_logic_vector (31 downto 0);

begin

    U1 : ifetch port map (
        clk,
        reset,
        inst_addr
    );

    U2 : imem port map (
        clk,
        inst_addr,
        inst_data
    );

    U3 : idecode port map (
        inst => inst_data,
        opcode => opcode,
        rd => rd,
        rs1 => rs1,
        rs2 => rs2,
        shamt => shamt,
        funct3 => funct3,
        funct7 => funct7,
        immediate => immediate
    );

    U4 : regs port map (
        clk => clk,
        reset => reset,
        rd => rd_wb,
        wdat => regs_write,
        wen => regs_wen_wb,
        rs1 => rs1,
        rs2 => rs2,
        rdat1 => rdat1,
        rdat2 => rdat2,
        debug_r => debug_r,
        debug_dat => debug_dat
    );

    U5 : control port map (
        funct3 => funct3,
        opcode => opcode,
        use_alt => use_alt,
        alu_src2_mux => alu_src2_mux,
        alu_op => alu_op,
        dmem_op => dmem_op,
        dmem_wen => dmem_wen,
        wb_mux => wb_mux,
        regs_wen => regs_wen
    );

    U6 : alu port map (
        clk => clk,
        opa => opa,
        opb => opb,
        op => alu_op_ex,
        use_alt => use_alt_ex,
        alt => immediate_ex (5),
        res => res
    );

    U7 : dmem port map (
        clk => clk,
        reset => reset,
        op => dmem_op_mem,
        dmem_waddr => res,
        dmem_wdat => rdat2_mem,
        dmem_wen => dmem_wen_mem,
        dmem_raddr => res,
        dmem_out => dmem_out
    );

    U8 : pmod_ssd port map (
        clk => clk,
        num => debug_dat (7 downto 0),
        ssd => ssd0,
        cs => ssd0_cs
    );

    process (clk) begin
        if rising_edge (clk) then
            alu_src2_mux_ex <= alu_src2_mux;
            alu_op_ex <= alu_op;
            immediate_ex <= immediate;
            use_alt_ex <= use_alt;
            rd_ex <= rd;
            rd_mem <= rd_ex;
            rd_wb <= rd_mem;
            res_wb <= res;
            rdat2_mem <= rdat2;
            dmem_wen_ex <= dmem_wen;
            dmem_wen_mem <= dmem_wen_ex;
            dmem_op_ex <= dmem_op;
            dmem_op_mem <= dmem_op_ex;
            regs_wen_ex <= regs_wen;
            regs_wen_mem <= regs_wen_ex;
            regs_wen_wb <= regs_wen_mem;
            wb_mux_ex <= wb_mux;
            wb_mux_mem <= wb_mux_ex;
            wb_mux_wb <= wb_mux_mem;
        end if;
    end process;

    -- MUX

    opa <= rdat1;

    with alu_src2_mux_ex select opb <=
        immediate_ex when "0",
        rdat2 when "1",
        (others => '-') when others;

    with wb_mux_wb select regs_write <=
        dmem_out when '1',
        res_wb when others;

    debug_r <= "01100";

end architecture behav;