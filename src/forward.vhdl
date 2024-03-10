library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forward is
    port (
        alu_reset : in std_logic;

        alu_rs1 : in std_logic_vector (4 downto 0);
        alu_rs2 : in std_logic_vector (4 downto 0);

        mem_rd : in std_logic_vector (4 downto 0);
        wb_rd : in std_logic_vector (4 downto 0);
        wb_n_rd : in std_logic_vector (4 downto 0);

        rs1_mux : out std_logic_vector (1 downto 0);
        rs2_mux : out std_logic_vector (1 downto 0)
    );
end entity forward;

architecture behav of forward is
begin

    rs1_mux <= (others => '0') when alu_reset = '1' else
        "01" when alu_rs1 = mem_rd else
        "10" when alu_rs1 = wb_rd else
        "11" when alu_rs1 = wb_n_rd else
        "00";

    rs2_mux <= (others => '0') when alu_reset = '1' else
        "01" when alu_rs2 = mem_rd else
        "10" when alu_rs2 = wb_rd else
        "11" when alu_rs2 = wb_n_rd else
        "00";

end architecture behav;