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
use IEEE.NUMERIC_STD.ALL;

entity periph_test is
    Port (  rot_A : in STD_LOGIC;
            rot_B : in STD_LOGIC;
            clk : in STD_LOGIC;
            value : in integer range 0 to 99;  -- Value to be displayed (0-99)
            ssd_display : out std_logic_vector(6 downto 0);  -- 7 segment display output
            c : out std_logic  -- digit select signal);
end periph_test;

architecture Behavioral of periph_test is
    --signal count : INTEGER range 1 to 10 := 1;
    signal last_A, last_B : STD_LOGIC := '0';
    signal tens_digit, ones_digit : integer range 0 to 9;
    signal count : unsigned(16 - 1 downto 0); -- alternating between digits
    signal c_temp : std_logic; -- temp var since "out" ports cannot be read in

begin
    process(clk)
    begin
        if rising_edge(clk) then
            last_A <= rot_A;
            last_B <= rot_B;
            count <= count + 1;
            -- Convert to BCD
            tens_digit <= TO_INTEGER(unsigned(value)) / 10;
            ones_digit <= TO_INTEGER(unsigned(value)) mod 10;

            -- Alternate digit selection
            c_temp <= count(count'high);

            -- detecting the direction of rotation
            if (rot_A/= last_A) then
                if (rot_A = '1') then
                    if (rot_B = '0') then
                        if value < 99 then
                            value <= value + 1;
                        end if;
                    else
                        if value > 1 then
                            value <= value - 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    -- display onto 2-digit seven segment display
    process (c_temp, tens_digit, ones_digit)
    begin
        -- Select digit based on c_temp
        case c_temp is
            when '0' =>
                case ones_digit is
                when 0 => ssd_display <= "0111111";
                when 1 => ssd_display <= "0000110";
                when 2 => ssd_display <= "1011011";
                when 3 => ssd_display <= "1001111";
                when 4 => ssd_display <= "1100110";
                when 5 => ssd_display <= "1101101";
                when 6 => ssd_display <= "1111101";
                when 7 => ssd_display <= "0000111";
                when 8 => ssd_display <= "1111111";
                when 9 => ssd_display <= "1101111";
                when others => ssd_display <= "0000000";  -- Default case
                end case;

            when others =>
                case tens_digit is
                when 0 => ssd_display <= "0111111";
                when 1 => ssd_display <= "0000110";
                when 2 => ssd_display <= "1011011";
                when 3 => ssd_display <= "1001111";
                when 4 => ssd_display <= "1100110";
                when 5 => ssd_display <= "1101101";
                when 6 => ssd_display <= "1111101";
                when 7 => ssd_display <= "0000111";
                when 8 => ssd_display <= "1111111";
                when 9 => ssd_display <= "1101111";
                when others => ssd_display <= "0000000";  -- Default case

            end case;
        end case;
    end process;

    -- Assign the common cathode/anode control signal
    c <= c_temp;

end Behavioral;
