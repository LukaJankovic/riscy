library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stall is
    port (
        clk : in std_logic;
        reset : in std_logic;

        opcode : in std_logic_vector (6 downto 0);

        jmp : in std_logic;
        stall_sig : out std_logic
    );
end entity stall;

architecture behav of stall is

    signal stall_ctr : unsigned (1 downto 0);

begin

    process (clk, reset) begin
        if reset = '1' then
            stall_ctr <= (others => '0');
            stall_sig <= '0';
        elsif rising_edge (clk) then
            if jmp = '1' then
                if opcode = "1101111" then
                    stall_ctr <= to_unsigned(0, 2);
                elsif opcode = "1100111" then
                    stall_ctr <= to_unsigned(1, 2);
                end if;
                stall_sig <= '1';
            elsif stall_ctr /= 0 then
                stall_ctr <= stall_ctr - 1;
                stall_sig <= '1';
            else
                stall_sig <= '0';
            end if;
        end if;
    end process;

end architecture behav;