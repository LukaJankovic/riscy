library ieee;

use ieee.std_logic_1164.all;

entity control is
    port(
        funct3 : in std_logic_vector (2 downto 0);
        opcode : in std_logic_vector (6 downto 0);

        alu_src2 : out std_logic_vector (0 downto 0)
    );
end entity control;

architecture behav of control is

begin

    with opcode select alu_src2 <=
        "0" when "0010011", -- IMM
        "1" when "0110011", -- RS2
        "-" when others;

end architecture behav;