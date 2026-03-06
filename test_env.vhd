
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
          
end test_env;


architecture Behavioral of test_env is

signal en: std_logic;
signal instruction: std_logic_vector(31 downto 0);
signal pcPlus4: std_logic_vector(31 downto 0);
signal JumpAddrforIFetch: std_logic_vector(31 downto 0);

signal res: std_logic_vector(31 downto 0);

signal RegDstUC : std_logic;
signal ExtOpUC : std_logic;
signal ALUSrcUC : std_logic;
signal BranchUC : std_logic;
signal JumpUC : std_logic;
signal ALUOpUC : std_logic_vector(1 downto 0);
signal MemWriteUC : std_logic;
signal MemtoRegUC : std_logic;
signal RegWriteUC : std_logic ;
signal Br_neUC : std_logic;
signal Br_gezUC : std_logic;

signal RD1ID: std_logic_vector(31 downto 0);
signal RD2ID: std_logic_vector(31 downto 0);
signal Ext_ImmID: std_logic_vector(31 downto 0);
signal funcID: std_logic_vector(5 downto 0);
signal saID: std_logic_vector(4 downto 0);
signal WDID: std_logic_vector(31 downto 0);

signal ZeroBeqEX: std_logic;
signal Br_gezEx: std_logic;
signal AluResEX: std_logic_vector(31 downto 0);
signal BranchAddressEX: std_logic_vector(31 downto 0);

signal MemDataMEM: std_logic_vector(31 downto 0);
signal AluRes_outMEM: std_logic_vector(31 downto 0);

signal Beq_res:std_logic;
signal Br_ne_res:std_logic;
signal Br_gez_res:std_logic;
signal result_branches: std_logic;

signal mux2_1_res: std_logic_vector(31 downto 0);

component mpg
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SSD
   Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component IFetch
    Port ( Jump: in std_logic;
         JumpAddress: in std_logic_vector(31 downto 0);
         PCSrc: in std_logic;
         BranchAddress: in std_logic_vector( 31 downto 0);
         en: in std_logic;
         rst: in std_logic;
         clk: in std_logic;
         instruction: out std_logic_vector( 31 downto 0);
         pcPlus4: out std_logic_vector(31 downto 0));
end component;

component UC 
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
end component;

component ID 
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
end component;

component EX 
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
end component;

component MEM
  Port (MemWrite: in std_logic;
        ALURes_in: in std_logic_vector(31 downto 0);
        RD2: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        en: in std_logic;
        MemData: out std_logic_vector(31 downto 0);
        ALURes_out: out std_logic_vector(31 downto 0) );
end component;

begin


led(11 downto 0)<=ALUOpUC&RegDstUC&ExtOpUC&ALUSrcUC&BranchUC&JumpUC&MemWriteUC&MemtoRegUC&RegWriteUC&Br_neUC&Br_gezUC;
process(sw(7 downto 5),instruction, pcPlus4,RD1ID,RD2ID,Ext_ImmID,ALUResEX,MemDataMEM,WDID)
  begin
    case sw(7 downto 5) is
        when "000" => res <= instruction;
        when "001" => res <= pcPlus4;
        when "010" => res <= RD1ID;
        when "011" => res <= RD2ID;
        when "100" => res <= Ext_immID;
        when "101" => res <= ALUResEX;
        when "110" => res <= MemDataMEM;
        when "111" => res <= WDID;
        when others => res <= X"00000000";
    end case;
end process;

JumpAddrforIFetch<=pcPlus4(31 downto 28)&instruction(25 downto 0)&"00";

Beq_res<=BranchUc and ZeroBeqEX;
Br_ne_res <= Br_neUC and (not ZeroBeqEX);
Br_gez_res <= Br_gezUC and Br_gezEX;
result_branches <= (Beq_res or Br_ne_res) or Br_gez_res;

mux2_1_res <= AluRes_outMEM when MemToRegUC='0' else MemDataMEM;

WDID <=mux2_1_res;

MPG_button_instance: mpg port map(en,btn(0),clk);
display : SSD port map (clk, res, an ,cat);
IFetch_connection : IFetch port map (JumpUC,JumpAddrforIFetch,result_branches,BranchAddressEX,en,btn(1),clk,instruction, pcPlus4);
UC_connect: UC port map (instruction(31 downto 26),RegDstUC,ExtOpUC,ALUSrcUC,BranchUC,JumpUC,ALUOpUC,MemWriteUC,MemtoRegUC,RegWriteUC,Br_neUC,Br_gezUC);
ID_connect: ID port map (RegWriteUC,instruction(25 downto 0),RegDstUC,en,ExtOpUC,mux2_1_res,RD1ID,RD2ID,Ext_ImmID,funcID,saID,clk);
Ex_connect: EX port map (RD1ID,ALUSrcUC,RD2ID,Ext_ImmID,saID,funcID,ALUOpUC,pcPlus4,ALUResEX,BranchAddressEX,ZeroBeqEX,Br_gezEX);
MEM_connect: MEM port map (MemWriteUC,AluResEX,RD2ID,clk,en,MemDataMEM,AluRes_outMEM);

end Behavioral;
