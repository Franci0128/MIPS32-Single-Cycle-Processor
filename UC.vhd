
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC is
   Port (Instr: in std_logic_vector(5 downto 0);
         RegDst: out std_logic;
         ExtOp: out std_logic;
         ALUSrc: out std_logic;
         Branch: out std_logic;
         Jump: out std_logic;
         ALUOp: out std_logic_vector(1 downto 0);
         MemWrite: out std_logic;
         MemtoReg: out std_logic;
         RegWrite: out std_logic;
         Br_ne: out std_logic;
         Br_gez: out std_logic);
end UC;

architecture Behavioral of UC is

begin
process(Instr)
  begin
    RegDst <= '0';
    ExtOp <= '0';
    ALUSrc <= '0';
    Branch <= '0';
    Jump <= '0';
    ALUOp <= "00";
    MemWrite <= '0';
    MemtoReg <= '0';
    RegWrite <= '0';
    Br_ne <= '0';
    Br_gez <= '0';
  
    case Instr is
    when "000000" => 
         RegDst <= '1';
         RegWrite <= '1';
         ALUOp <= "00";
    when "000001" => 
         RegDst <= '1';
         RegWrite <= '1';
         ALUOp <= "00";
    when "000010" => 
         RegDst <= '1';
         RegWrite <= '1';
         ALUOp <= "00";
    when "000011" => 
         RegDst <= '1';
         RegWrite <= '1';
         ALUOp <= "00";
    when "000100" => 
         RegDst <= '1';
         RegWrite <= '1';
         ALUOp <= "00";
    when "000101" => 
         RegDst <= '1';
         RegWrite <= '1';
         ALUOp <= "00";
    when "000110" => 
         RegDst <= '1';
         RegWrite <= '1';
         ALUOp <= "00";
    when "000111" => 
         RegDst <= '1';
         RegWrite <= '1';
         ALUOp <= "00";
    when "001001" => 
         ExtOp <= '1';
         ALUSrc <= '1';
         RegWrite <= '1';
         ALUOp <= "01";
    when "001010" => 
         ExtOp <= '1';
         ALUSrc <= '1';
         MemtoReg <= '1';
         RegWrite <= '1';
         ALUOp <= "01"; 
    when "001011" => 
         ExtOp <= '1';
         ALUSrc <= '1';
         MemWrite <= '1';
         ALUOp <= "01";
    when "001100" => 
         ExtOp <= '1';
         Branch <= '1';
         ALUOp <= "10";
    when "001101" =>
         ExtOp <= '1';
         Br_gez <= '1';
         ALUOp <= "10"; 
    when "001110" => 
         ExtOp <= '1';
         Br_ne <= '1';
         ALUOp <= "10";
    when "001111" =>   
         Jump <= '1'; 
    when others =>
    
    end case;
end process;


end Behavioral;
