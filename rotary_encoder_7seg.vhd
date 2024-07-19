----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/18/2024 10:10:37 PM
-- Design Name: 
-- Module Name: periph_test - Behavioral
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


entity periph_test is
    Port ( rot_A : in STD_LOGIC;
           rot_B : in STD_LOGIC;
           clk : in STD_LOGIC;
           ssd_display_01 : out STD_LOGIC_VECTOR (6 downto 0)
           ssd_display_10 :  out STD_LOGIC_VECTOR (6 downto 0));
end periph_test;

architecture Behavioral of periph_test is
    signal count : INTEGER range 1 to 10 := 1;
    signal last_A, last_B : STD_LOGIC := '0';
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            last_A <= rot_A;
            last_B <= rot_B;
            -- detecting the direction of rotation
            if (rot_A/= last_A) then
                if (rot_A = '1') then
                    if (rot_B = '0') then
                        if count < 10 then
                            count <= count + 1;
                        end if;
                    else
                        if count > 1 then
                            count <= count - 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    process(count)
    begin
        case (count % 10) is
            when 0 => ssd_display_01 <= "0000110"; -- Display 0
            when 1 => ssd_display_01 <= "1011011"; -- Display 1
            when 2 => ssd_display_01 <= "1001111"; -- Display 2
            when 3 => ssd_display_01 <= "1100110"; -- Display 3
            when 4 => ssd_display_01 <= "1101101"; -- Display 4
            when 5 => ssd_display_01 <= "1111101"; -- Display 5
            when 6 => ssd_display_01 <= "0000111"; -- Display 6
            when 7 => ssd_display_01 <= "1111111"; -- Display 7
            when 8 => ssd_display_01 <= "1101111"; -- Display 8
            when 9 => ssd_display_01 <= "1110111"; -- Display 9
            when others => ssd_display_01 <= "0000000"; -- turn off the display
        end case;

        -- need to set pins for 10s place in constraint
        case ((count / 10) % 10) is
            when 0 => ssd_display_10 <= "0000110"; -- Display 0
            when 1 => ssd_display_10 <= "1011011"; -- Display 1
            when 2 => ssd_display_10 <= "1001111"; -- Display 2
            when 3 => ssd_display_10 <= "1100110"; -- Display 3
            when 4 => ssd_display_10 <= "1101101"; -- Display 4
            when 5 => ssd_display_10 <= "1111101"; -- Display 5
            when 6 => ssd_display_10 <= "0000111"; -- Display 6
            when 7 => ssd_display_10 <= "1111111"; -- Display 7
            when 8 => ssd_display_10 <= "1101111"; -- Display 8
            when 9 => ssd_display_10 <= "1110111"; -- Display 9
            when others => ssd_display_10 <= "0000000"; -- turn off the display
        end case;
    end process;
end Behavioral;
