library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ifetch is
    port (
        clk : in std_logic;
        reset : in std_logic;

        opcode : in std_logic_vector (6 downto 0);

        offset : in std_logic_vector (31 downto 0);
        rdat1 : in std_logic_vector (31 downto 0);
        jmp : in std_logic;
        stall_sig : in std_logic;

        inst_addr : out std_logic_vector (31 downto 0)
    );
end entity ifetch;

architecture behav of ifetch is

    signal pc : std_logic_vector (31 downto 0);
    signal pc_next : std_logic_vector (31 downto 0);

    signal opcode_next : std_logic_vector (6 downto 0);

    signal jmp_next : std_logic;

begin

    pc_next <= std_logic_vector (unsigned(offset) + unsigned(rdat1)) when opcode_next = "1100111" and jmp_next = '1' -- JALR
               else
               std_logic_vector (unsigned(pc) + unsigned(offset) - 4) when opcode = "1101111" and jmp = '1' -- JAL
               else
               std_logic_vector (unsigned (pc) + 4);

    process (clk, reset) begin
        if reset = '1' then
            pc <= (others => '0');
        elsif rising_edge (clk) then
            pc <= pc_next;
        end if;
    end process;

    process (clk, reset) begin
        if reset = '1' then
            opcode_next <= (others => '0');
        elsif rising_edge (clk) then
            opcode_next <= opcode;
        end if;
    end process;

    process (clk, reset) begin
        if reset = '1' then
            jmp_next <= '0';
        elsif rising_edge (clk) then
            jmp_next <= jmp;
        end if;
    end process;

    inst_addr <= pc;

end architecture behav;