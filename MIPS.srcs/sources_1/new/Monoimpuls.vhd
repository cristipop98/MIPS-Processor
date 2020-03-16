----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2019 09:21:18 PM
-- Design Name: 
-- Module Name: Monoimpuls - Behavioral
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

entity Monoimpuls is
  Port (
  clock:in std_logic;
  input:in std_logic;
  output:out std_logic );
end Monoimpuls;

architecture Behavioral of Monoimpuls is
signal count_int:std_logic_vector(31 downto 0):=x"00000000";
signal q1:std_logic;
signal q2:std_logic;
signal q3:std_logic;
begin
output<=q2 and (not q3);
process(clock)
begin
if clock='1' and clock'event then
count_int<=count_int+1;
end if;
end process;
process(clock)
begin
if clock'event and clock='1' then
if count_int(15 downto 0)="1111111111111111" then
q1<=input;
end if;
end if;
end process;
process(clock)
begin
if clock'event and clock='1' then
q2<=q1;
q3<=q2;
end if;
end process;
end Behavioral;
