library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pmod_ssd is
    port (
        clk : in std_logic;
        num : in std_logic_vector (7 downto 0);

        ssd : out std_logic_vector (6 downto 0);
        cs : out std_logic
    );
end entity pmod_ssd;

architecture behav of pmod_ssd is

    type mapping_array is array (0 to 15) of std_logic_vector (6 downto 0);
    constant mapping : mapping_array := (
        b"0111111",
        b"0000110",
        b"1011011",
        b"1001111",
        b"1100110",
        b"1101101",
        b"1111101",
        b"0000111",
        b"1111111",
        b"1101111",
        b"1110111",
        b"1111100",
        b"0111001",
        b"1011110",
        b"1111001",
        b"1110001"
    );

    alias low : std_logic_vector (3 downto 0) is num (3 downto 0);
    alias high : std_logic_vector (3 downto 0) is num (7 downto 4);

    signal slow_clk : unsigned (7 downto 0) := (others => '0');
    signal switch : std_Logic;

    signal current : std_logic_vector (3 downto 0);
    signal current_sel : std_logic := '0';

begin

    process (clk) begin
        if rising_edge (clk) then
            slow_clk <= slow_clk + 1;

            if (slow_clk = 0) then
                switch <= '1';
            else
                switch <= '0';
            end if;
        end if;
    end process;

    process (clk) begin
        if rising_edge (clk) then
            if (switch = '1') then
                current_sel <= not current_sel;
            end if;
        end if;
    end process;

    process (clk) begin
        if rising_edge (clk) then
            if (switch = '1') then
                if (current_sel = '0') then
                    current <= high;
                else
                    current <= low;
                end if;
            end if;
        end if;
    end process;

    cs <= current_sel;
    ssd <= mapping (to_integer (unsigned (current)));

end architecture behav;