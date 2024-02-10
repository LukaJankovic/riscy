library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
        opa : std_logic_vector (31 downto 0);
        opb : std_logic_vector (31 downto 0);

        alu_op : std_logic_vector (2 downto 0)
    );
end entity alu;

architecture behav of alu is
begin
end architecture behav;