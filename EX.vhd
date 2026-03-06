
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EX is
  Port (RD1: std_logic_vector( 31 downto 0);
        ALUSrc: in std_logic;
        RD2: in std_logic_vector(31 downto 0);
        Ext_Imm: std_logic_vector(31 downto 0);
        sa: in std_logic_vector(4 downto 0);
        func: in std_logic_vector(5 downto 0);
        ALUOp: in std_logic_vector(1 downto 0);
        pcPlus4: in std_logic_vector(31 downto 0);
        ALURes: out std_logic_vector(31 downto 0);
        BranchAddress: out std_logic_vector(31 downto 0);
        Zero_Beq: out std_logic;
        Br_gez: out std_logic );
end EX;

architecture Behavioral of EX is

signal ALUCtrl: std_logic_vector(2 downto 0);

signal A: std_logic_vector(31 downto 0);
signal B: std_logic_vector(31 downto 0);
signal C: std_logic_vector(31 downto 0);
signal Ext_Imm_ext: std_logic_vector(31 downto 0);

begin
ALUControl: process (ALUOp, func)
   begin
    case ALUOp is   
     when "00" =>
       case func is
         when "000000" => ALUCtrl <= "000";
         when "000001" => ALUCtrl <= "001";
         when "000010" => ALUCtrl <= "010";
         when "000011" => ALUCtrl <= "011";
         when "000100" => ALUCtrl <= "100";
         when "000101" => ALUCtrl <= "101";
         when "000110" => ALUCtrl <= "110";
         when "000111" => ALUCtrl <= "111";
         when others => ALUCtrl <=(others=> 'X');
       end case;
     when "01" => ALUCtrl <= "000";
     when "10" => ALUCtrl <= "001";
     when others => ALUCtrl <=(others=> 'X'); 
   end case;
 end process;
 
A<=RD1;
B<=RD2 when ALUSrc <= '0' else Ext_Imm;
Ext_Imm_ext <= Ext_Imm(29 downto 0) & "00";
BranchAddress <= Ext_Imm_ext + pcPlus4;
ALURes <= C;

Zero_Beq <= '1' when C =X"00000000" else '0';
Br_gez <= not C(31);

process(ALUCtrl)
begin
  case ALUCtrl is
     when "000" => C <= A+B;
     when "001" => C <= A-B;
     when "010" => C <= to_stdlogicvector(to_bitvector(B) sll conv_integer(sa));
     when "011" => C <= to_stdlogicvector(to_bitvector(B) srl conv_integer(sa));
     when "100" => C <= A and B;
     when "101" => C <= A or B;
     when "110" => C <= A xor B;
     when "111" => if signed(A) < signed(B) then C <= X"00000001";
                                            else C <= X"00000000";
                   end if;
     when others => C <=(others=>'X');
   end case;
end process;

end Behavioral;
