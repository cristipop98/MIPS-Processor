----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2019 05:24:57 PM
-- Design Name: 
-- Module Name: test_if - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_if is
  Port (
       clk : in STD_LOGIC;
           btn :in std_logic_vector(3 downto 0);
           sw :in std_logic_vector(15 downto 0);
           cat :out std_logic_vector(6 downto 0);
           led:out std_logic_vector(15 downto 0);
           an:out std_logic_vector(3 downto 0)
   );
end test_if;

architecture Behavioral of test_if is
signal btn1:std_logic;
signal btn0:std_logic;
signal next_pc:std_logic_vector(15 downto 0);
signal instruction:std_logic_vector(15 downto 0);
signal out_mux:std_logic_vector(15 downto 0);

signal regDst:std_logic:='0';
signal extOp:std_logic:='0';
signal ALUsrc:std_logic:='0';
signal branch:std_logic:='0';
signal jump:std_logic:='0';
signal ALUop:std_logic_vector(2 downto 0):="000";
signal memWrite:std_logic:='0';
signal memToReg:std_logic:='0';
signal regWrite:std_logic:='0';
signal zero:std_logic:='0';

signal in0: std_logic_vector(15 downto 0) := X"0000";--
signal in1: std_logic_vector(15 downto 0) := X"0000";--
signal rd1: std_logic_vector(15 downto 0) := X"0000";--rd1
signal rd2: std_logic_vector(15 downto 0) := X"0000";--rd2
signal wd: std_logic_vector(15 downto 0) := X"0000";--wd
signal extImm: std_logic_vector(15 downto 0) := X"0000";--extImm
signal func: std_logic_vector(2 downto 0);--funct
signal sa: std_logic := '0';
signal digits: std_logic_vector(15 downto 0) := X"0000";--digits ssd
signal sel: std_logic_vector(2 downto 0) := "000";
signal AluRes:std_logic_vector(15 downto 0):=x"0000";
signal Baddr:std_logic_vector(15 downto 0):=x"0000";
signal Brench_Address:std_logic_vector(15 downto 0):=x"0000";
signal MemData:std_logic_vector(15 downto 0):=x"0000";
signal AluResOut:std_logic_vector(15 downto 0):=x"0000";
signal AluResIn:std_logic_vector(15 downto 0):=x"0000";
signal JAddr:std_logic_vector(15 downto 0):=x"0000";

signal RegIF_ID:std_logic_vector(31 downto 0);
signal RegID_EX:std_logic_vector(81 downto 0);
signal RegEX_MEM:std_logic_vector(56 downto 0);
signal RegMEM_WB:std_logic_vector(37 downto 0);

component SSD
 Port (
       digit:in std_logic_vector(15 downto 0);
       clk:in std_logic;
       cat:out std_logic_vector(6 downto 0);
       an:out std_logic_vector(3 downto 0) );
end component;
component Monoimpuls
     Port (
        clock:in std_logic;
        input:in std_logic;
        output:out std_logic );
    end component;
component INSTR_IF
    Port(
    SRST:in std_logic;
        clk:in std_logic;
        en:in std_logic;
        baddr:in std_logic_vector(15 downto 0);
        jaddr:in std_logic_vector(15 downto 0);
        jump:in std_logic;
        pcsrc:in std_logic;
        instruction:out std_logic_vector(15 downto 0);
        nextpc:inout std_logic_vector(15 downto 0)
        );
    end component;
  component ID is
  Port(
   clk:in std_logic;
    instructiune:in std_logic_vector(15 downto 0);
    en:in std_logic;
    wd:in std_logic_vector(15 downto 0);
    ExtOp:in std_logic;
    RegDst:in std_logic;
    RegWrite:in std_logic;
    rd1:out std_logic_vector(15 downto 0);
    rd2:out std_logic_vector(15 downto 0);
    extImm: out std_logic_vector(15 downto 0);
    func:out std_logic_vector(2 downto 0);
    sa:out std_logic
    );
    end component;    
 component SSD1 is
  Port (
        digit:in std_logic_vector(15 downto 0);
        clk:in std_logic;
        cat:out std_logic_vector(6 downto 0);
        an:out std_logic_vector(3 downto 0) );
 end component;
 component Ex is
    Port (
        rd1:in std_logic_vector(15 downto 0);
        ALUSrc:in std_logic;
        rd2:in std_logic_vector(15 downto 0);
        Ext_Imm:in std_logic_vector(15 downto 0);
        sa:in std_logic;
        func:in std_logic_vector(2 downto 0);
        ALUOp:in std_logic_vector(2 downto 0);
        Zero:out std_logic;
        ALURes:out std_logic_vector(15 downto 0);
        pc:in std_logic_vector(15 downto 0);
        Brench_Address:out std_logic_vector(15 downto 0)
   );
   end component;
   component Mem is
    Port (
        clk:in std_logic;
        ALUResIn:inout std_logic_vector(15 downto 0);
        rd2:in std_logic_vector(15 downto 0);
        MemWrite:in std_logic;
        MemData:out std_logic_vector(15 downto 0);
       -- ALUResOut:out std_logic_vector(15 downto 0);
        en:in std_logic
        
   );
   end component;
begin
D:Monoimpuls port map(clk,btn(1),btn1);
D1:Monoimpuls port map(clk,btn(0),btn0);
--I1:INSTR_IF port map(btn1,clk,btn0,x"1000",x"0000",sw[0],sw[1],instruction,next_pc);
--JAddr(15 downto 13)<=next_pc(15 downto 13);
--JAddr(12 downto 0)<=instruction(12 downto 0);
JAddr<=next_pc(15 downto 13) & instruction(12 downto 0);
I1:INSTR_IF port map(btn1,clk,btn0,Baddr,JAddr,jump,sw(1),instruction,next_pc);
I2:ID port map(clk,instruction,btn1,wd,extOp,regDst,regWrite,rd1,rd2,extImm,func,sa);
wd<=rd1+rd2;
process(sw(7),instruction,next_pc)
    begin
        case sw(7) is
            when '0'=>out_mux<=instruction;
            when '1'=>out_mux<=next_pc;
        end case;
end process;
S:SSD port map(digits,clk,cat,an);
E:Ex port map(rd1,ALUsrc,rd2,extImm,sa,func,ALUOp,zero,AluRes,next_pc,Baddr);
M:Mem port map(clk,AluRes,rd2,MemWrite,MemData,btn1);
AluResOut<=AluRes;
process(instruction)
begin
    regDst<='0';
        extOp<='0';
        ALUsrc<='0';
        branch<='0';
        jump<='0';
        ALUop<="000";
        memWrite<='0';
        memToReg<='0';
        regWrite<='0';
    case(instruction(15 downto 13)) is
    --"000";--ADDI
    --"001";--ADD
    --"010";--BEQ
    --"011";--SW
    --"100";--JUMP
         when "010"=>regDst<='0';
                      ExtOp<='0';
                      ALUsrc<='1';
                      branch<='0';
                      jump<='0';
                      ALUop<="000";
                      memWrite<='0';
                      memToReg<='0';
                      regWrite<='1';
            when "000"=>regDst<='1';
                      ExtOp<='0';
                      ALUsrc<='1';
                      branch<='0';
                      jump<='0';
                      ALUop<="001";
                      memWrite<='0';
                      memToReg<='0';
                      regWrite<='1';
            when "110"=>regDst<='0';
                      ExtOp<='0';
                      ALUsrc<='1';
                      branch<='1';
                      jump<='0';
                      ALUop<="011";
                      memWrite<='0';
                      memToReg<='0';
                      regWrite<='0';
            when "100"=>regDst<='0';
                      ExtOp<='0';
                      ALUsrc<='1';
                      branch<='0';
                      jump<='1';
                      ALUop<="100";
                      memWrite<='0';
                      memToReg<='0';
                      regWrite<='0';
            when "011"=>regDst<='0';
                      ExtOp<='0';
                      ALUsrc<='1';
                      branch<='0';
                      jump<='0';
                      ALUop<="110";
                      memWrite<='1';
                      memToReg<='0';
                      regWrite<='0';
            when others=>regDst<='0';
                         extOp<='0';
                         ALUsrc<='0';
                         branch<='0';
                         jump<='0';
                         ALUop<="000";
                         memWrite<='0';
                         memToReg<='0';
                         regWrite<='0';
      end case;
      end process;
    led(0)<=regDst;
    led(1)<=extOp;
    led(2)<=ALUsrc;
    led(3)<=branch;
    led(4)<=jump;
    led(5)<=memWrite;
    led(6)<=memToReg;
    led(7)<=regWrite;

    sel<=sw(7 downto 5);
    --MUX
    process(sel)
    begin
        case(sel) is
            when "000" => digits<=instruction;
            when "001" => digits<=next_pc;
            when "010" => digits<=rd1;
            when "011" => digits<=rd2;
            when "111" => digits<=wd;
            when "100" => digits<=extImm;
            when "101"=>digits<=AluRes;
            when "110"=>digits<=MemData;
            when others => digits<=X"0000";
        end case;
    end process;
    
    --MUX iesire mem
    process(MemData,AluResOut,memToReg)
        begin
        case memToReg is
            when'1'=>wd<=MemData;
            when'0'=>wd<=AluResOut;
         end case;
     end process;
     
    --IF/ID Reg
    process(clk)
    begin
        if clk'event and clk='1' then
            if btn1='1' then
                RegIF_ID(31 downto 0)<=next_pc;
                RegIF_ID(15 downto 0)<=instruction;
            end if;
        end if;
     end process;
     
     --ID/EX Reg
     process(clk)
     begin
        if clk'event and clk='1' then
            if btn1='1' then
                RegID_EX(2 downto 0)<=RegIF_ID(2 downto 0);
                RegID_EX(5 downto 3)<=RegIF_ID(6 downto 4);
                RegID_EX(8 downto 6)<=RegIF_ID(9 downto 7);
                RegID_EX(24 downto 9)<=extImm;
                RegID_EX(39 downto 25)<=rd2;
                RegID_EX(56 downto 40)<=rd1;
                RegID_EX(72 downto 57)<=RegIF_ID(31 downto 16);
                RegID_EX(77 downto 73)<=ALUop & ALUsrc & regDst;
                RegID_EX(79 downto 78)<=memWrite & Branch;
                RegID_EX(81 downto 80)<=MemToReg & regWrite;
            end if;
         end if;
      end process;
      
    --EX/MEM Reg
    process(clk)
    begin
        if clk'event and clk='1' then
            if btn1='1' then
                --RegEX_MEM(3 downto 0)<=;
                RegEX_MEM(19 downto 4)<= RegID_EX(39 downto 25);
                RegEX_MEM(35 downto 20)<=AluRes;
                RegEX_MEM(36)<=zero;
                RegEX_MEM(52 downto 37)<=Baddr;
                RegEX_MEM(54 downto 53)<=RegID_EX(79 downto 78);
                RegEX_MEM(56 downto 55)<=RegID_EX(81 downto 80);
            end if;
        end if;
     end process;
     
     --MEM/WB
     process(clk)
     begin
        if clk'event and clk='1' then
            if btn1='1' then
                RegMEM_WB(3 downto 0)<=RegEX_MEM(3 downto 0);
                RegMEM_WB(19 downto 4)<=RegEX_MEM(35 downto 20);
                RegMEM_WB(35 downto 20)<=MemData;
                RegMEM_WB(37 downto 36)<=RegEX_MEM(56 downto 55);
            end if;
        end if;
      end process;
    

end Behavioral;
