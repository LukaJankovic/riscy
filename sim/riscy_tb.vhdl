library ieee;
use ieee.std_logic_1164.all;

entity riscy_tb is
end entity;

architecture behav of riscy_tb is

    constant clk_period : time := 8 ns;
    
    component riscy_top is
        port(
            clk : in std_logic;
            reset : in std_logic
        );
    end component;

    signal clk_tb : std_logic := '0';
    signal reset_tb : std_logic;

begin

    process begin
        clk_tb <= not clk_tb;
        wait for clk_period / 2;
    end process;

    U1 : riscy_top port map (
        clk => clk_tb,
        reset => reset_tb
    );

end architecture;