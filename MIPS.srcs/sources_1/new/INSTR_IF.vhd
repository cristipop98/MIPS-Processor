----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2019 04:48:47 PM
-- Design Name: 
-- Module Name: INSTR_IF - Behavioral
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

entity INSTR_IF is
  Port (
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
end INSTR_IF;

architecture Behavioral of INSTR_IF is
signal q:std_logic_vector(15 downto 0);
signal mux:std_logic_vector(15 downto 0);
signal mux1:std_logic_vector(15 downto 0);
type mem is array(0 to 15) of std_logic_vector(15 downto 0);
signal rom:mem:=(
            0=>B"010_000_001_0000000",-- 4080
            1=>B"010_000_010_0000001",-- 4101
            2=>B"010_000_100_0001010",-- 420A
            3=>B"000_000_000_011_0_000",--0030
            4=>B"000_000_000_101_0_000",-- 0050
            5=>B"011_100_101_0000111",-- 7287
            6=>B"000_001_010_011_0_000",-- 0530
            7=>B"110_010_001_0001010",--  C88A 
            8=>B"110_011_010_0001011",--  CD0B
            9=>B"010_000_101_0000001",-- 4281
            10=>B"100_0000000000101",-- 8005
            others=>x"0000"
    );

begin
    --pc
    process(clk)
        begin
            if(clk'event and clk='1') then
                if SRST='1' then
                    q<=x"0000";
                elsif en='1' then
                q<=mux;
                end if;
            end if;
    end process;
       --ADD
       nextpc<=q+1;
       --ROM
        instruction<=rom(conv_integer(q(3 downto 0)));
       --MUX1
       process(nextpc,baddr,pcsrc)
       begin
        case pcsrc is
            when '0'=> mux1<=nextpc;
            when '1'=>mux1<=baddr;
        end case;
      end process;
       --MUX2
       process(jump,jaddr,mux1)
       begin
         case jump is
             when '0' =>mux<=mux1;
             when '1'=>mux<=jaddr;
         end case;
       end process;
   

end Behavioral;
