
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFetch is
  Port ( Jump: in std_logic;
         JumpAddress: in std_logic_vector(31 downto 0);
         PCSrc: in std_logic;
         BranchAddress: in std_logic_vector( 31 downto 0);
         en: in std_logic;
         rst: in std_logic;
         clk: in std_logic;
         instruction: out std_logic_vector( 31 downto 0);
         pcPlus4: out std_logic_vector(31 downto 0));
end IFetch;

architecture Behavioral of IFetch is

signal q:std_logic_vector(31 downto 0);
signal d:std_logic_vector(31 downto 0);
signal sum:std_logic_vector(31 downto 0);
signal mux1:std_logic_vector(31 downto 0);
signal data: std_logic_vector(31 downto 0) := X"00000000";

type t_mem is array (0 to 31) of std_logic_vector(31 downto 0);
signal mem: t_mem:=(
B"001001_00000_00010_0111111111111111", -- X"24027FFF",   00: ADDI $2, $0, 32767 Initializeaza R2 cu 32767 (valoare maxima)
B"001001_00000_00011_0000000000000000", -- X"24030000",   01: ADDI $3, $0, 0 Initializeaza indexul R3 cu 0
B"001010_00000_00001_0000000000000100", -- X"28010004",   02: LW $1, 4($0) Citeste N (numarul de elemente) din memorie la adresa 4

-- loop
B"000000_00000_00011_00110_00010_000010", -- X"00033082", 03: SLL $6, $3, 2 Calculeaza offsetul: index * 4
B"001010_00110_00111_0000000000001000", -- X"28C70008",   04: LW $7, 8($6) Incarca valoarea din sir (sirul incepe la memorie[8])

B"000000_00111_00000_00100_00000_000111", -- X"00E02007", 05:  SLT $4, $7, $0 Verifica daca valoarea este negativa <0
B"001110_00100_00000_0000000000000011", -- X"38800003",   06: BNE $4, $0, skip_update Daca este negativa , sari peste actualizare
B"000000_00111_00010_00100_00000_000111", -- X"00E22007", 07:  SLT $4, $7, $2 Verifica daca valoarea curenta este mai mica decat minimul
B"001100_00100_00000_0000000000000001", -- X"30800001",   08: BEQ $4, $0, skip_update Daca nu este mai mica, sari peste actualizare

B"000000_00000_00111_00010_00000_000000", -- X"00071000", 09: ADD $2, $0, $7 Actualizeaza minimul cu valoarea curenta

-- skip_update
B"001001_00011_00011_0000000000000001", -- X"24630001",   10: ADDI $3, $3, 1 Incrementeaza indexul
B"001100_00011_00001_0000000000000001", -- X"30610001",   11: BEQ $3, $1, end_loop Daca indexul == N, sari la final, scriem valoarea in memorie
B"001111_00000000000000000000000011", -- X"3C000003",     12: J loop Sare la inceputul buclei (PC = 3)

B"101011_00000_00010_0000000000000000", -- X"AC020000",   13: SW $2, 0($0) Scrie valoarea minima in memorie la adresa 0

-- end_loop
B"000000_00000_00000_00000_00000_000000", -- X"00000000", 14: end_loop: Incheie programul

others => X"00000000"
);

begin

sum<=q + X"00000004";
pcPlus4 <=sum;
data<=mem(conv_integer(q(6 downto 2)));
instruction<=data;

 process(clk,rst)
   begin
     if rst='1' then
        q<=( others => '0');
     elsif rising_edge(clk) then
       if en='1' then
          q<=d;
       end if;
     end if;
 end process;

process(PCSrc, BranchAddress, sum)
  begin
    if PCSrc= '1' then
      mux1<=BranchAddress;
    else 
      mux1<=sum;
    end if;
end process;

process(mux1, JumpAddress,Jump)
  begin
     if Jump='1' then 
        d<=JumpAddress;
     else 
        d<=mux1;
     end if;
end process;

end Behavioral;
