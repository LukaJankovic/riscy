library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dmem is
    port (
        clk : in std_logic;

        dmem_waddr : in std_logic_vector (31 downto 0);
        dmem_wdat : in std_logic_vector (31 downto 0);
        dmem_wen : in std_logic;

        dmem_raddr : in std_logic_vector (31 downto 0);

        dmem_out : out std_logic_vector (31 downto 0)
    );
end entity dmem;

architecture behav of dmem is

    type dmem_type is array (0 to 31) of bit_vector (31 downto 0);

    signal dmem_ram : dmem_type := (others => (others => '0'));

begin

    process (clk) begin
        if rising_edge (clk) then
            dmem_out <= to_stdlogicvector (dmem_ram (to_integer (unsigned (dmem_raddr))));

            if (dmem_wen = '1') then
                dmem_ram (to_integer (unsigned (dmem_waddr))) <= to_bitvector (dmem_wdat);
            end if;
        end if;
    end process;

end architecture behav;