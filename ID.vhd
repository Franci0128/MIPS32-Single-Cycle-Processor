
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ID is
  Port (RegWrite: in std_logic;
        Instr: in std_logic_vector(25 downto 0);
        RegDst: in std_logic;
        En: in std_logic ;
        ExtOp: in std_logic;
        WD: in std_logic_vector(31 downto 0);
        RD1: out std_logic_vector(31 downto 0);
        RD2: out std_logic_vector(31 downto 0);
        Ext_Imm: out std_logic_vector( 31 downto 0);
        func: out std_logic_vector(5 downto 0);
        sa: out std_logic_vector(4 downto 0);
        clk: in std_logic);
end ID;

architecture Behavioral of ID is
type Register_File is array (0 to 31) of std_logic_vector(31 downto 0);
signal RF : Register_File:= (
  others => X"00000000"
);

signal writeAddress: std_logic_vector(4 downto 0);
signal writeData: std_logic_vector(31 downto 0);

begin

RD1<=RF(conv_integer(Instr(25 downto 21)));
RD2<=RF(conv_integer(Instr(20 downto 16)));
writeData<=WD;
func<=Instr(5 downto 0);
sa<=Instr(10 downto 6);
Ext_Imm(15 downto 0) <= Instr(15 downto 0);
Ext_Imm(31 downto 16) <= (others => Instr(15)) when ExtOp = '1' else  (others => '0');
 
process(clk)
   begin
     if rising_edge(clk) then
         if en='1' and Regwrite='1' then
            RF(conv_integer(writeAddress))<=writeData;
         end if;
     end if;
end process;

process(RegDst, Instr(20 downto 16), Instr(15 downto 11))
begin 
   if RegDst='1' then 
      writeAddress<=Instr(15 downto 11);
   else 
      writeAddress<=Instr(20 downto 16);
   end if;
end process;

    
end Behavioral;
