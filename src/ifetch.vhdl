library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ifetch is
    port (
        clk : in std_logic;
        reset : in std_logic;

        inst_addr : out std_logic_vector (31 downto 0)
    );
end entity ifetch;

architecture behav of ifetch is
    
    signal pc : std_logic_vector (31 downto 0);
    signal pc_next : std_logic_vector (31 downto 0);

begin

    pc_next <= std_logic_vector (unsigned (pc) + 4);

    process (clk, reset) begin
        if reset = '1' then
            pc <= (others => '0');
        elsif rising_edge (clk) then
            pc <= pc_next;
        end if;
    end process;

    inst_addr <= pc;

end architecture behav;