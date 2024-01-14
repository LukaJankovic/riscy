library ieee;
use ieee.std_logic_1164.all;

entity and_gate is
    port(
        x : in std_logic;
        y : in std_logic;
        z : out std_logic
    );
end entity;

architecture behav of and_gate is
    signal a : std_logic;
begin
    a <= x;
    z <= a and y;
end architecture;