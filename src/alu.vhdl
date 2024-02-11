library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
        opa : in std_logic_vector (31 downto 0);
        opb : in std_logic_vector (31 downto 0);

        funct3 : in std_logic_vector (2 downto 0);

        res : out std_logic_vector (31 downto 0)
    );
end entity alu;

architecture behav of alu is
begin
    res <= std_logic_vector (unsigned (opa) + unsigned (opb)) when funct3 = "000" else
           (others => '0');
end architecture behav;