library ieee;

use ieee.std_logic_1164.all;

entity control is
    port (
        funct3 : in std_logic_vector (2 downto 0);
        opcode : in std_logic_vector (6 downto 0);

        use_alt : out std_logic;
        alu_src1_mux : out std_logic_vector (1 downto 0);
        alu_src2_mux : out std_logic_vector (1 downto 0);
        alu_op : out std_logic_vector (2 downto 0);

        dmem_op : out std_logic_vector (2 downto 0);
        dmem_wen : out std_logic;

        wb_mux : out std_logic;
        regs_wen : out std_logic;

        jmp : out std_logic
    );
end entity control;

architecture behav of control is

begin

    with opcode select alu_src2_mux <=
        "00" when "0110111" | "0010011" | "0100011" | "0000011" | "0010111", -- IMM
        "01" when "0110011", -- RS2
        "10" when "1101111" | "1100111", -- 4 (JAL, JALR)
        "--" when others;

    with opcode select alu_src1_mux <=
        "01" when "0010111" | "1101111", -- PC (AUIPC, JAL)
        "00" when others; -- RS1

    with opcode select use_alt <=
        '1' when "0010011",
        '0' when others;

    with opcode select alu_op <=
        funct3 when "0010011" | "0110011",
        "000" when others;

    with opcode select dmem_op <=
        funct3 when "0100011" | "0000011",
        "111" when others;

    with opcode select dmem_wen <=
        '1' when "0100011",
        '0' when others;

    with opcode select wb_mux <=
        '1' when "0000011",
        '0' when others;

    with opcode select regs_wen <=
        '1' when "0110111" | "0010011" | "0110011" | "0000011" | "0010111" | "1101111",
        '0' when others;

    with opcode select jmp <=
        '1' when "1101111" | "1100111" | "1100011",
        '0' when others;

end architecture behav;