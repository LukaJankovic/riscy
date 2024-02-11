library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscy_top is
    port (
        clk : in std_logic;
        reset : in std_logic
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
            rdat2 : out std_logic_vector (31 downto 0)
        );
    end component regs;

    component control is
        port(
            funct3 : in std_logic_vector (2 downto 0);
            opcode : in std_logic_vector (6 downto 0);

            alu_src2 : out std_logic_vector (0 downto 0)
        );
    end component control;

    -- alu stage

    component alu is
        port (
            opa : in std_logic_vector (31 downto 0);
            opb : in std_logic_vector (31 downto 0);

            funct3 : in std_logic_vector (2 downto 0);

            res : out std_logic_vector (31 downto 0)
        );
    end component alu;

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

    signal funct3_ex : std_logic_vector (2 downto 0);
    signal immediate_ex : std_logic_vector (31 downto 0);

    signal rdat1 : std_logic_vector (31 downto 0);
    signal rdat2 : std_logic_vector (31 downto 0);

    signal alu_src2 : std_logic_vector (0 downto 0);
    signal alu_src2_ex : std_logic_vector (0 downto 0);

    signal opa : std_logic_vector (31 downto 0);
    signal opb : std_logic_vector (31 downto 0);
    signal res : std_logic_vector (31 downto 0);

    signal res_mem : std_logic_vector (31 downto 0);
    signal res_wb : std_logic_vector (31 downto 0);

    signal regs_wen : std_logic;
    signal regs_wen_ex : std_logic;
    signal regs_wen_mem : std_logic;
    signal regs_wen_wb : std_logic;

begin

    U1 : ifetch port map(
        clk,
        reset,
        inst_addr
    );

    U2 : imem port map(
        clk,
        inst_addr,
        inst_data
    );

    U3 : idecode port map(
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

    U4 : regs port map(
        clk => clk,
        reset => reset,
        rd => rd_wb,
        wdat => res_wb,
        wen => regs_wen_wb,
        rs1 => rs1,
        rs2 => rs2,
        rdat1 => rdat1,
        rdat2 => rdat2
    );

    U5 : control port map(
        funct3 => funct3,
        opcode => opcode,
        alu_src2 => alu_src2
    );

    U6 : alu port map(
        opa => opa,
        opb => opb,
        funct3 => funct3_ex,
        res => res
    );

    process (clk) begin
        if rising_edge (clk) then
            alu_src2_ex <= alu_src2;
            funct3_ex <= funct3;
            immediate_ex <= immediate;
            rd_ex <= rd;
            rd_mem <= rd_ex;
            rd_wb <= rd_mem;
            res_mem <= res;
            res_wb <= res_mem;
            regs_wen_ex <= regs_wen;
            regs_wen_mem <= regs_wen_ex;
            regs_wen_wb <= regs_wen_mem;
        end if;
    end process;

    opa <= rdat1;

    with alu_src2_ex select opb <=
        immediate_ex when "0",
        rdat2 when "1",
        (others => '-') when others;

    with opcode select regs_wen <=
        '1' when "0010011" | "0110011",
        '0' when others;

end architecture behav;