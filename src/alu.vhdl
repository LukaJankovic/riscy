library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
        clk : in std_logic;

        opa : in std_logic_vector (31 downto 0);
        opb : in std_logic_vector (31 downto 0);

        funct3 : in std_logic_vector (2 downto 0);
        use_alt : in std_logic;
        alt : in std_logic;

        res : out std_logic_vector (31 downto 0)
    );
end entity alu;

architecture behav of alu is

    signal res_internal : unsigned (31 downto 0);

begin

    process (clk) begin
        if rising_edge (clk) then

            res_internal <= (others => '0');

            case funct3 is
                when "000" =>
                    if (use_alt = '1' and alt = '1') then
                        res_internal <= unsigned (opa) - unsigned (opb);
                    else
                        res_internal <= unsigned (opa) + unsigned (opb);
                    end if;
                when "001" =>
                    res_internal <= shift_left (unsigned (opa), to_integer (unsigned (opb)));
                when "010" =>
                    if (signed (opa) < signed (opb)) then
                        res_internal <= to_unsigned(1, 32);
                    else
                        res_internal <= to_unsigned(0, 32);
                    end if;
                when "011" =>
                    if (unsigned (opa) < unsigned (opb)) then
                        res_internal <= to_unsigned(1, 32);
                    else
                        res_internal <= to_unsigned(0, 32);
                    end if;
                when "100" =>
                    res_internal <= unsigned (opa xor opb);
                when "101" =>
                    if (use_alt = '1' and alt = '1') then
                        res_internal <= shift_right (unsigned (opa), to_integer (signed (opb)));
                    else
                        res_internal <= shift_right (unsigned (opa), to_integer (unsigned (opb)));
                    end if;
                when "110" =>
                    res_internal <= unsigned (opa or opb);
                when "111" =>
                    res_internal <= unsigned (opa and opb);
                when others =>
                    res_internal <= (others => '0');
            end case;
        end if;
    end process;

    res <= std_logic_vector (res_internal);

end architecture behav;