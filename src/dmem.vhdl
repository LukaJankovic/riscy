library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dmem is
    port (
        clk : in std_logic;
        reset : in std_logic;

        op : in std_logic_vector (2 downto 0);

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

    signal wdat : std_logic_vector (31 downto 0);
    signal dout : std_logic_vector (31 downto 0);

    signal op_n : std_logic_vector (2 downto 0);

begin

    process (clk) begin
        if rising_edge (clk) then
            op_n <= op;
        end if;
    end process;

    process (clk, reset) begin
        if reset = '1' then
            dmem_ram <= (others => (others => '0'));
        elsif rising_edge (clk) then
            dout <= to_stdlogicvector (dmem_ram (to_integer (unsigned (dmem_raddr))));

            if (dmem_wen = '1') then
                dmem_ram (to_integer (unsigned (dmem_waddr))) <= to_bitvector (wdat);
            end if;
        end if;
    end process;

    with op_n select dmem_out <=
        (31 downto 8 => dout (7)) & dout (7 downto 0) when "000",
        (31 downto 16 => dout (15)) & dout (15 downto 0) when "001",
        dout when "010",
        (others => '0') when others;

    with op select wdat <=
        (31 downto 8 => dmem_wdat (7)) & dmem_wdat (7 downto 0) when "000",
        (31 downto 16 => dmem_wdat (15)) & dmem_wdat (15 downto 0) when "001",
        dmem_wdat when "010",
        (others => '0') when others;

end architecture behav;