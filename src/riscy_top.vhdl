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

            rs1 : in std_logic_vector (4 downto 0);
            rs2 : in std_logic_vector (4 downto 0);

            rdat1 : out std_logic_vector (31 downto 0);
            rdat2 : out std_logic_vector (31 downto 0)
        );
    end component regs;

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

    signal rdat1 : std_logic_vector (31 downto 0);
    signal rdat2 : std_logic_vector (31 downto 0);

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

end architecture;