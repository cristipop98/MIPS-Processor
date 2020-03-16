----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2019 04:28:09 PM
-- Design Name: 
-- Module Name: SSD_DRIVER - Behavioral
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

entity SSD is
  Port (
        digit:in std_logic_vector(15 downto 0);
        clk:in std_logic;
        cat:out std_logic_vector(6 downto 0);
        an:out std_logic_vector(3 downto 0) );
end SSD;

architecture Behavioral of SSD is
signal counter:std_logic_vector(15 downto 0):="0000000000000000";
signal m1:std_logic_vector(3 downto 0);
--signal nr1:std_logic_vector(3 downto 0):="1110";
--signal nr2:std_logic_vector(3 downto 0):="1101";
--signal nr3:std_logic_vector(3 downto 0):="1011";
--signal nr4:std_logic_vector(3 downto 0):="0111";
begin
process(clk)
begin
if clk'event and clk='1' then
counter<=counter+1;
end if;
end process;
process(counter(15 downto 14),digit)
begin
    case counter(15 downto 14) is
         when"00" =>m1<=digit(3 downto 0);
         when"01" =>m1<=digit(7 downto 4);
         when"10" =>m1<=digit(11 downto 8);
         when"11" =>m1<=digit(15 downto 12);
   end case;
 end process;
process(counter(15 downto 14))
begin
    case counter(15 downto 14) is
    when"00"=>an<="1110";
    when"01"=>an<="1101";
    when"10"=>an<="1011";
    when"11"=>an<="0111";
   end case;
   end process;
  --SSD 7 SEGMENTE
    with m1 SELect
     cat<= "1111001" when "0001",   --1
           "0100100" when "0010",   --2
           "0110000" when "0011",   --3
           "0011001" when "0100",   --4
           "0010010" when "0101",   --5
           "0000010" when "0110",   --6
           "1111000" when "0111",   --7
           "0000000" when "1000",   --8
           "0010000" when "1001",   --9
           "0001000" when "1010",   --A
           "0000011" when "1011",   --b
           "1000110" when "1100",   --C
           "0100001" when "1101",   --d
           "0000110" when "1110",   --E
           "0001110" when "1111",   --F
           "1000000" when others;   --0

    
end Behavioral;
