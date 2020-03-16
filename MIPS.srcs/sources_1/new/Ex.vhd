----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2019 04:27:42 PM
-- Design Name: 
-- Module Name: Ex - Behavioral
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

entity Ex is
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
end Ex;

architecture Behavioral of Ex is
signal out_mux:std_logic_vector(15 downto 0);
signal Aluctrl:std_logic_vector(2 downto 0);
begin
    Brench_Address<=pc+Ext_Imm;
    
    process(ALUSrc,rd2,Ext_Imm)
    begin
        case ALUSrc is
            when '0'=>out_mux<=rd2;
            when '1'=>out_mux<=Ext_Imm;
         end case;
    end process;
    --aluControl
    process(ALUOp,func)
    begin
        case ALUOp is
           when"010"=>Aluctrl<="000";--ADDI
           when"000"=>Aluctrl<="001";--ADD
           when"011"=>Aluctrl<="010";--BEQ
           when"110"=>Aluctrl<="011";--SW
           when"100"=>Aluctrl<="100";--JUMP
           when others=>ALUctrl<="111";
         end case;
     end process;
     
     --ALU
     process(Aluctrl,out_mux,rd1)
     begin
        case Aluctrl is
            when"000"=>AluRes<=rd1+Ext_Imm;
            when"001"=>AluRes<=rd1+out_mux;
            when"010"=>AluRes<=rd1-out_mux;
            when"011"=>AluRes<=out_mux;
            when"100"=>AluRes<=Ext_Imm;
            when others=>AluRes<=x"0000";
           end case;
      end process;
   
end Behavioral;
