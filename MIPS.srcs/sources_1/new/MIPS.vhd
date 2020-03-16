----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2019 04:19:52 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn :in std_logic_vector(3 downto 0);
           sw :in std_logic_vector(15 downto 0);
           cat :out std_logic_vector(6 downto 0);
           led:out std_logic_vector(15 downto 0);
           an:out std_logic_vector(3 downto 0));
end test_env;
architecture Behavioral of test_env is
signal s1:std_logic;
signal reset:std_logic;
signal pc:std_logic_vector(3 downto 0);
signal out_rom:std_logic_vector(15 downto 0);
signal mem1:std_logic_vector(15 downto 0);
type mem is array(0 to 15) of std_logic_vector(15 downto 0);
signal rom:mem:=(
            0=>B"010_000_001_0000000",--ADDI $1, $0, 0 4080
            1=>B"010_000_001_0000001",--ADDI $2, $0, 1 4081
            2=>B"010_000_100_0001010",--ADDI $4, $0, 10 420A
            3=>B"000_000_000_011_0_000",--ADD $3, $0, $0 0030
            4=>B"000_000_000_101_0_000",--ADD $5, $0, $0 0050
            5=>B"011_100_101_0000111",--BEQ  $5, $4, 7 7287
            6=>B"000_001_010_011_0_000",--ADD $3, $1, $2 0530
            7=>B"110_010_001_0001010",--SW $1, 10($2)  C88A 
            8=>B"110_011_010_0001011",--SW $2, 11($3)  CD0B
            9=>B"010_000_101_0000001",--ADDI $5, $0, 1 4281
            10=>B"100_0000000000100",--J 4  8004
            others=>x"0000"
    );
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
begin
process(clk)
begin
if (clk'event and clk='1') then
    if s1='1' then
        pc<=pc+1;
    end if;
end if;
end process;
--process(pc)
  --  begin
    --    case pc is
      --      when "0000" => out_rom <=rom(0);
        --    when "0001" =>out_rom <= rom(1);
          --  when "0010" => out_rom <= rom(2);
           -- when "0011" => out_rom<= rom(3);
           -- when "0100" => out_rom <= rom(4);
           -- when "0101" => out_rom <= rom(5);
           -- when "0110" => out_rom <= rom(6);
           -- when "0111" => out_rom <= rom(7);
           -- when "1000" => out_rom <= rom(8);
            --when "1001" =>out_rom <= rom(9);
            --when "1010" => out_rom <= rom(10);
            --when "1011" => out_rom<= rom(11);
            --when "1100" => out_rom <= rom(12);
            --when "1101" => out_rom <= rom(13);
            --when "1110" => out_rom <= rom(14);
            --when "1111" => out_rom <= rom(15);
            --when others => out_rom <= "0000000000000000";
	    --end case;
--end process;
out_rom<=rom(conv_integer(pc));
SSD1:SSD port map(out_rom,clk,cat,an);
D:Monoimpuls port map(clk,btn(0),s1);
end Behavioral;