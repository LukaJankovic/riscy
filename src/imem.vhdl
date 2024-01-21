library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity imem is
    port (
        clk : in std_logic;

        inst_addr : in unsigned (31 downto 0);
        inst_out : out unsigned (31 downto 0)
    );
end imem;

architecture behav of imem is

    type imem_type is array (0 to 31) of bit_vector (31 downto 0);

    impure function init_ram(file_name : in string) return imem_type is
        file ram_file : text is in file_name;
        variable file_line : line;
        variable imem : imem_type;
    begin
        for i in imem_type'range loop
            readline(ram_file, file_line);
            read(file_line, imem(i));
        end loop;
        return imem;
    end function;

    signal imem_ram : imem_type := init_ram ("../prog/strlen.bin");

    --signal imem_ram : imem_type := (
    --    x"00000293",
    --    x"00a28333",
    --    x"00030303",
    --    x"00030663",
    --    x"00128293",
    --    x"ff1ff06f",
    --    x"00028513",
    --    x"00008067",
    --    others => (others => '0')
    --);

begin

    process (clk) begin
        if rising_edge (clk) then
            inst_out <= unsigned (to_stdlogicvector (imem_ram (to_integer (inst_addr) / 4)));
        end if;
    end process;

end architecture;