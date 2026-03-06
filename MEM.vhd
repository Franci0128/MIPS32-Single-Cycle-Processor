
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is
  Port (MemWrite: in std_logic;
        ALURes_in: in std_logic_vector(31 downto 0);
        RD2: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        en: in std_logic;
        MemData: out std_logic_vector(31 downto 0);
        ALURes_out: out std_logic_vector(31 downto 0) );
end MEM;

architecture Behavioral of MEM is
type t_mem is array (0 to 63) of std_logic_vector(31 downto 0);

signal MEM: t_mem:=(
   --- aici o sa pun sirul de valori pt exercitiu in hexa
        X"00000000",  -- Rezultatul va fi plasat la adresa 0
        X"00000003",  -- Valoarea N = 3
        X"00000005",  -- Valoarea 5 la adresa 8 
        X"FFFFFFFD", -- Valoarea -3 la adresa 9      
        X"00000001",
        others => X"00000000" 
);

signal Address: std_logic_vector(5 downto 0);
signal WriteData: std_logic_vector(31 downto 0);
signal ReadData: std_logic_vector(31 downto 0);

begin

WriteData<=RD2;
Address<= ALURes_in(7 downto 2);
ALURes_out<=ALURes_in;  
ReadData<=MEM(conv_integer(Address));
MemData<=ReadData;  

process(clk)
  begin
    if rising_edge(clk) then 
       if en='1' and MemWrite='1' then
        MEM(conv_integer(Address))<=WriteData;
       end if;
    end if;
end process;

end Behavioral;
