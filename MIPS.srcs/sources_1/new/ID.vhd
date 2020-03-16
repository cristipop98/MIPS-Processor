----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2019 05:10:39 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
  Port (
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
end ID;

architecture Behavioral of ID is
component Reg_file is
Port (
        clk:in std_logic;
        ra1:in std_logic_vector(2 downto 0);
        ra2:in std_logic_vector(2 downto 0);
        wa:in std_logic_vector(2 downto 0);
        wd:in std_logic_vector(15 downto 0);
        wen:in std_logic;
        rd1:out std_logic_vector(15 downto 0);
        rd2:out std_logic_vector(15 downto 0)
   );
   end component;
signal out_regDst:std_logic_vector(2 downto 0);
signal instr1:std_logic_vector(2 downto 0);
signal instr2:std_logic_vector(2 downto 0);  
   begin
   RF1:Reg_file port map(clk,instr1,instr2,out_regDst,wd,RegWrite,rd1,rd2);
   instr1<=instructiune(12 downto 10);
   instr2<=instructiune(9 downto 7);
   process(RegDst,instructiune(9 downto 7),instructiune(6 downto 4))
    begin
        case RegDst is
            when '0'=>out_regDst<=instructiune(9 downto 7);
            when '1'=>out_regDst<=instructiune(6 downto 4);
        end case;
   end process;
   func<=instructiune(2 downto 0);
   sa<=instructiune(3);
   
   process(ExtOp,instructiune(6 downto 0))
    begin
        case ExtOp is
            when '0'=>extImm<="000000000" & instructiune(6 downto 0);
            when '1'=>extImm<="111111111" & instructiune(6 downto 0);
        end case;
    end process;
            
end Behavioral;
