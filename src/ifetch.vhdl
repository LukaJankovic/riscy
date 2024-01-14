library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ifetch is
    port (
        clk : in std_logic;
        reset : in std_logic;

        inst_addr : out unsigned (31 downto 0)
    );
end ifetch;

architecture behav of ifetch is
    
    signal pc : unsigned (31 downto 0);
    signal pc_next : unsigned (31 downto 0);

begin

    pc_next <= pc + 4;

    process (clk, reset) begin
        if reset = '1' then
            pc <= (others => '0');
        elsif rising_edge (clk) then
            pc <= pc_next;
        end if;
    end process;

    inst_addr <= pc;

end architecture;