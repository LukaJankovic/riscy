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

    signal inst_addr : unsigned (31 downto 0);
    signal inst_data : unsigned (31 downto 0);

begin

    U1 : ifetch port map (
        clk,
        reset,
        inst_addr
    );

    U2 : imem port map (
        clk,
        inst_addr,
        inst_data
    );

end architecture;