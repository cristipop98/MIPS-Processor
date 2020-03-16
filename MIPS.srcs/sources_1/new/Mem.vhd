----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2019 05:14:12 PM
-- Design Name: 
-- Module Name: Mem - Behavioral
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

entity Mem is
  Port (
        clk:in std_logic;
        ALUResIn:inout std_logic_vector(15 downto 0);
        rd2:in std_logic_vector(15 downto 0);
        MemWrite:in std_logic;
        MemData:out std_logic_vector(15 downto 0);
        --ALUResOut:out std_logic_vector(15 downto 0);
        en:in std_logic
        
   );
end Mem;

architecture Behavioral of Mem is
type ram_type is array (0 to 15) of std_logic_vector (15 downto 0);
 signal RAM1: ram_type; 
 component RAM is
     Port (
    clk:in std_logic;
    we:in std_logic;
    en:in std_logic;
    addr:in std_logic_vector(15 downto 0);
    di:in std_logic_vector(15 downto 0);
    do:out std_logic_vector(15 downto 0)
  
   );
   end component;
begin
R:RAM port map(clk,MemWrite,en,ALUResIn,rd2,MemData);
--ALUResOut<=ALUResIn;
              

    


end Behavioral;
