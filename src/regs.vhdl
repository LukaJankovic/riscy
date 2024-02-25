library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regs is
    port (
        clk : in std_logic;
        reset : in std_logic;

        rd : in std_logic_vector (4 downto 0);
        wdat : in std_logic_vector (31 downto 0);
        wen : in std_logic;

        rs1 : in std_logic_vector (4 downto 0);
        rs2 : in std_logic_vector (4 downto 0);

        rdat1 : out std_logic_vector (31 downto 0);
        rdat2 : out std_logic_vector (31 downto 0);

        debug_r : in std_logic_vector (4 downto 0);
        debug_dat : out std_logic_vector (31 downto 0)
    );
end entity regs;

architecture behav of regs is

    type regs_type is array (0 to 31) of std_logic_vector (31 downto 0);

    signal regs_file : regs_type := (others => (others => '0'));

begin

    process (clk, reset) begin
        if reset = '1' then
            regs_file <= (others => (others => '0'));
        elsif rising_edge (clk) then
            rdat1 <= regs_file (to_integer (unsigned (rs1)));
            rdat2 <= regs_file (to_integer (unsigned (rs2)));

            if (wen = '1') then
                regs_file (to_integer (unsigned (rd))) <= wdat;
            end if;
        end if;
    end process;

    debug_dat <= regs_file (to_integer (unsigned (debug_r)));

end architecture behav;