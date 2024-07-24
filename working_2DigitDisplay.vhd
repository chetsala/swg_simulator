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
    add : in std_logic;  -- Add input
    subtract : in std_logic;  -- Subtract input
    sw : in std_logic_vector(3 downto 0);  -- Switch input for testing
    ssd_display : out std_logic_vector(6 downto 0);  -- 7-segment display output
    c : out std_logic  -- Digit select signal
  );
end sevenSeg;

architecture behavioral of sevenSeg is

    signal tens_digit, ones_digit : integer range 0 to 9;
    signal value, num : integer range 0 to 99 := 0;
    signal count : unsigned(15 downto 0) := (others => '0');  -- Alternating between digits
    signal c_temp : std_logic;  -- Temp variable since "out" ports cannot be read in
    
    -- Debouncing signals
    constant DEBOUNCE_MAX : integer := 100000;  -- Adjust debounce time as needed
    signal add_debounce_counter, subtract_debounce_counter : integer := 0;
    signal add_stable, subtract_stable : std_logic := '0';
    signal debounce_flag : std_logic := '0';

begin
    -- Debouncing process for "add" button
    process(clk, reset)
    begin
        if reset = '1' then
            add_debounce_counter <= 0;
            add_stable <= '0';
        elsif rising_edge(clk) then
            if add = '1' then
                if add_debounce_counter < DEBOUNCE_MAX then
                    add_debounce_counter <= add_debounce_counter + 1;
                else
                    add_stable <= '1';
                end if;
            else
                add_debounce_counter <= 0;
                add_stable <= '0';
            end if;
        end if;
    end process;

    -- Debouncing process for "subtract" button
    process(clk, reset)
    begin
        if reset = '1' then
            subtract_debounce_counter <= 0;
            subtract_stable <= '0';
        elsif rising_edge(clk) then
            if subtract = '1' then
                if subtract_debounce_counter < DEBOUNCE_MAX then
                    subtract_debounce_counter <= subtract_debounce_counter + 1;
                else
                    subtract_stable <= '1';
                end if;
            else
                subtract_debounce_counter <= 0;
                subtract_stable <= '0';
            end if;
        end if;
    end process;

    -- Main process to handle add/subtract logic and update 7-segment display
    process(clk, reset)
    begin
        if reset = '1' then
            num <= 0;
            count <= (others => '0');
            c_temp <= '0';
            tens_digit <= 0;
            ones_digit <= 0;
        elsif rising_edge(clk) then
            -- Add/Subtract logic
            if add_stable = '1' and debounce_flag = '0' and num < 99 then
                num <= num + 1;
                debounce_flag <= '1';
            elsif subtract_stable = '1' and debounce_flag = '0' and num > 0 then
                num <= num - 1;
                debounce_flag <= '1';
            elsif add_stable = '0' and subtract_stable = '0' then
                debounce_flag <= '0';
            end if;
            
            -- Update 7-segment display value based on switches
            if sw = "0001" then
                value <= 99;
            elsif sw = "0010" then
                value <= 21;
            elsif sw = "0100" then
                value <= num;
            else
                value <= to_integer(unsigned(sw));
            end if;
            
            -- Convert to BCD
            tens_digit <= value / 10;
            ones_digit <= value mod 10;
            
            -- Alternate digit selection
            count <= count + 1;
            c_temp <= count(count'high);
        end if;
    end process;

    -- 7-segment display logic
    process(c_temp, tens_digit, ones_digit)
    begin
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
