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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sevenSeg is
  port (
    clk : in std_logic;  -- Clock input
    reset : in std_logic;  -- Reset input
    value : in STD_LOGIC_VECTOR (3 downto 0); -- used to test w/switches, replace 'value' in process (clk, reset)
--    value : in integer range 0 to 99;  -- Value to be displayed (0-99)
    ssd_display : out std_logic_vector(6 downto 0);  -- 7 segment display output
    c : out std_logic  -- digit select signal
  );
end sevenSeg;

architecture behavioral of sevenSeg is

    signal tens_digit, ones_digit : integer range 0 to 9;
    signal count : unsigned(16 - 1 downto 0); -- alternating between digits
    signal c_temp : std_logic; -- temp var since "out" ports cannot be read in

begin

    process (clk, reset)
        begin
        if reset = '1' then
            count <= (others => '0');
            c_temp <= '0';
            tens_digit <= 0;
            ones_digit <= 0;
        elsif rising_edge(clk) then
            count <= count + 1;

            -- Convert to BCD
      tens_digit <= TO_INTEGER(unsigned(value)) / 10; -- use when value == switches
      ones_digit <= TO_INTEGER(unsigned(value)) mod 10; -- use when value == switches
      --tens_digit <= value / 10; -- use when value == integer
      --ones_digit <= value mod 10; -- use when value == integer

            -- Alternate digit selection
            c_temp <= count(count'high);
        end if;
    end process;

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

end architecture;
