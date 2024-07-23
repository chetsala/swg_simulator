----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/23/2024 04:54:03 PM
-- Design Name: 
-- Module Name: SWG_SYS - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity SWG_SYS is
    Port ( CLK      : in  STD_LOGIC;
           SW       : in  STD_LOGIC_VECTOR (3 downto 0);
           BTN      : in  STD_LOGIC_VECTOR (4 downto 0);
           LED5     : out STD_LOGIC_VECTOR (2 downto 0);
           LED6     : out STD_LOGIC_VECTOR (2 downto 0);
           ssd_display  : out STD_LOGIC_VECTOR (6 downto 0);
           c : out STD_LOGIC);
end SWG_SYS;

architecture Behavioral of SWG_SYS is
-- Constants
    constant SALT_MIN : integer := 5;
    constant SALT_MAX : integer := 12;
    constant TEMP_MIN : integer := 7;

    -- Types
    type state_type is (INIT, SET_POOL_SIZE, SET_TEMP, SET_SALT, NORMAL_OP);
    type display_type is (POOL_SIZE, TEMPERATURE, SALT, NORMAL);

    -- Signals
    signal current_state : state_type := INIT;
    signal display_state : display_type := POOL_SIZE;
    signal pool_gal : integer range 0 to 15 := 0;
    signal temp : integer range 0 to 15 := 8;
    signal salt_level : integer range 0 to 15 := 0;
    signal pump_on : boolean := false;
    signal system_good : boolean := false;
    
    -- 7-segment display signals
    signal ssd_value : integer range 0 to 99 := 0;
    signal ssd_refresh_counter : unsigned(19 downto 0) := (others => '0');
    signal ssd_activedigit : std_logic_vector(1 downto 0) := (others => '0');

    -- Button debounce signals
    signal btn_debounce_counter : unsigned(19 downto 0) := (others => '0');
    signal debounced_buttons : std_logic_vector(4 downto 0) := (others => '0');

    -- New signals for seven segment display
    signal tens_digit, ones_digit : integer range 0 to 9;
    signal count : unsigned(16 - 1 downto 0); -- alternating between digits
    signal c_temp : std_logic; -- temp var since "out" ports cannot be read in

begin
    -- Main process
    process(CLK)
    begin
        if rising_edge(CLK) then
            -- Button debounce
            btn_debounce_counter <= btn_debounce_counter + 1;
            if btn_debounce_counter = 0 then
                debounced_buttons <= BTN;
            end if;

            -- State machine
            case current_state is
                when INIT =>
                    current_state <= SET_POOL_SIZE;
                    display_state <= POOL_SIZE;
                
                when SET_POOL_SIZE =>
                    if debounced_buttons(4) = '1' then  -- BTN4 pressed
                        pool_gal <= to_integer(unsigned(SW));
                        current_state <= SET_TEMP;
                        display_state <= TEMPERATURE;
                    end if;
                
                when SET_TEMP =>
                    if debounced_buttons(4) = '1' then  -- BTN4 pressed
                        temp <= to_integer(unsigned(SW));
                        current_state <= SET_SALT;
                        display_state <= SALT;
                    end if;
                
                when SET_SALT =>
                    if debounced_buttons(4) = '1' then  -- BTN4 pressed
                        salt_level <= to_integer(unsigned(SW));
                        current_state <= NORMAL_OP;
                        display_state <= NORMAL;
                    end if;
                
                when NORMAL_OP =>
                    -- Handle pump on/off
                    if debounced_buttons(2) = '1' then  -- BTN2 pressed
                        pump_on <= not pump_on;
                    end if;
                    
                    -- Handle add salt
                    if debounced_buttons(3) = '1' then  -- BTN3 pressed
                        if salt_level < 15 then
                            salt_level <= salt_level + 1;
                        end if;
                    end if;
                    
                    -- Handle temperature adjustment
                    if debounced_buttons(0) = '1' and temp < 15 then  -- BTN0 pressed
                        temp <= temp + 1;
                    elsif debounced_buttons(1) = '1' and temp > 0 then  -- BTN1 pressed
                        temp <= temp - 1;
                    end if;
                    
                    -- Check system status
                    if temp > TEMP_MIN and salt_level >= SALT_MIN and salt_level <= SALT_MAX then
                        system_good <= true;
                    else
                        system_good <= false;
                    end if;
            end case;

            -- Update display value
            case display_state is
                when POOL_SIZE => ssd_value <= pool_gal;
                when TEMPERATURE => ssd_value <= temp;
                when SALT => ssd_value <= salt_level;
                when NORMAL => ssd_value <= to_integer(unsigned(SW));
            end case;

            -- Update LEDs
            if pump_on then
                LED5 <= "010";  -- Green
            else
                LED5 <= "100";  -- Red
            end if;

            if current_state /= NORMAL_OP then
                LED6 <= "110";  -- Yellow
            elsif system_good then
                LED6 <= "010";  -- Green
            else
                LED6 <= "100";  -- Red
            end if;

            -- Update 7-segment display digits
            count <= count + 1;
            tens_digit <= ssd_value / 10;
            ones_digit <= ssd_value mod 10;
            c_temp <= count(count'high);
        end if;
    end process;

    -- 7-segment display digit multiplexing
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
                    when 9 => ssd_display <= "1100111";
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
                    when 9 => ssd_display <= "1100111";
                    when others => ssd_display <= "0000000";  -- Default case
                end case;
        end case;
    end process;

    -- Active digit selection
    c <= c_temp;

end Behavioral;
