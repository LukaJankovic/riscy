library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity idecode is
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
end entity idecode;

architecture behav of idecode is

    signal opcode_internal : std_logic_vector (6 downto 0);

begin

    opcode <= inst (6 downto 0);
    opcode_internal <= inst (6 downto 0);

    rd <= inst (11 downto 7);

    rs1 <= inst (19 downto 15);
    rs2 <= inst (24 downto 20);

    shamt <= inst (24 downto 20);

    funct3 <= inst (14 downto 12);
    funct7 <= inst (31 downto 25);

    with opcode_internal select immediate <=
        inst (31 downto 12) & (11 downto 0 => '0')                                              when "0110111" | "0010111", -- B type
        (31 downto 20 => inst(31)) & inst(19 downto 12) & inst(20) & inst(30 downto 21) & '0'   when "1101111", -- J type
        (31 downto 11 => inst(31)) & inst(30 downto 20)                                         when "1100111" | "0000011" | "0010011"  | "1110011", -- I type
        (31 downto 12 => inst(31)) & inst(7) & inst(30 downto 25) & inst(11 downto 8) & '0'     when "1100011", -- B type
        (31 downto 11 => inst(31)) & inst(30 downto 25) & inst(11 downto 7)                     when "0100011", -- S type
        (others => '0') when others;

end architecture behav;