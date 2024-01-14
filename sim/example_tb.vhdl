library ieee;
use ieee.std_logic_1164.all;

entity example_tb is
end entity;

architecture behav of example_tb is
    
    component and_gate is
        port(
            x : in std_logic;
            y : in std_logic;
            z : out std_logic
        );
    end component;

    signal x_in : std_logic;
    signal y_in : std_logic;
    signal z_out : std_logic;

begin

    x_in <= '1';
    y_in <= '0';

    U1 : and_gate port map (
        x => x_in,
        y => y_in,
        z => z_out
    );

end architecture;