library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forward is
    port (
        alu_rs1 : in std_logic_vector (4 downto 0);
        alu_rs2 : in std_logic_vector (4 downto 0);

        mem_rd : in std_logic_vector (4 downto 0);
        wb_rd : in std_logic_vector (4 downto 0);

        rs1_mux : out std_logic_vector (1 downto 0);
        rs2_mux : out std_logic_vector (1 downto 0)
    );
end entity forward;

architecture behav of forward is
begin

    with alu_rs1 select rs1_mux <=
        "10" when mem_rd,
        "01" when wb_rd,
        "00" when others;

    with alu_rs2 select rs2_mux <=
        "10" when mem_rd,
        "01" when wb_rd,
        "00" when others;

end architecture behav;