library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscy_top is
    port (
        clk : in std_logic;
        reset : in std_logic
    );
end entity;

architecture behav of riscy_top is

    component ifetch is
        port (
            clk : in std_logic;
            reset : in std_logic;

            inst_addr : out unsigned (31 downto 0)
        );
    end component;

    component imem is
        port (
            clk : in std_logic;

            inst_addr : in unsigned (31 downto 0);
            inst_out : out unsigned (31 downto 0)
        );
    end component;

    component idecode is
        port (
            inst : in unsigned (31 downto 0);

            opcode : out unsigned (6 downto 0);

            rd : out unsigned (4 downto 0);
            rs1 : out unsigned (4 downto 0);
            rs2 : out unsigned (4 downto 0);

            shamt : out unsigned (4 downto 0);

            funct3 : out unsigned (2 downto 0);
            funct7 : out unsigned (6 downto 0);

            immediate : out unsigned (31 downto 0)
        );
    end component;

    signal inst_addr : unsigned (31 downto 0);
    signal inst_data : unsigned (31 downto 0);

    signal opcode : unsigned (6 downto 0);
    signal rd : unsigned (4 downto 0);
    signal rs1 : unsigned (4 downto 0);
    signal rs2 : unsigned (4 downto 0);
    signal shamt : unsigned (4 downto 0);
    signal funct3 : unsigned (2 downto 0);
    signal funct7 : unsigned (6 downto 0);
    signal immediate : unsigned (31 downto 0);

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