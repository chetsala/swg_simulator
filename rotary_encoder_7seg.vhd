library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sevenSeg is
    port (
        clk : in std_logic;  -- Clock input
        reset : in std_logic;  -- Reset input
        rot_A : in std_logic; -- Rotary Encoder A input
        rot_B : in std_logic; -- Rotary Encoder B input
        -- add : in std_logic;  -- Add input
        -- subtract : in std_logic;  -- Subtract input
        ssd_display : out std_logic_vector(6 downto 0);  -- 7 segment display output
        c : out std_logic  -- digit select signal
    );
end sevenSeg;

architecture behavioral of sevenSeg is

    signal tens_digit, ones_digit : integer range 0 to 9;
    signal value : integer range 0 to 99 := 0;  -- Value to be displayed (0-99)
    signal count : unsigned(15 downto 0) := (others => '0'); -- alternating between digits
    signal c_temp : std_logic; -- temp var since "out" ports cannot be read in

    signal last_encoder_A : std_logic := '0';

    -- Debouncing signals
    constant DEBOUNCE_MAX : integer := 100000;  -- Adjust debounce time as needed
    signal rot_A_debounce_counter, rot_B_debounce_counter : integer := 0;
    signal rot_A_stable, rot_B_stable : std_logic := '0';
    signal debounce_flag : std_logic := '0';

begin
    -- Debouncing process for "rot_A"
    process(clk, reset)
    begin
        if reset = '1' then
            rot_A_debounce_counter <= 0;
            rot_A_stable <= '0';
        elsif rising_edge(clk) then
            if rot_A = '1' then
                if rot_A_debounce_counter < DEBOUNCE_MAX then
                    rot_A_debounce_counter <= rot_A_debounce_counter + 1;
                else
                    rot_A_stable <= '1';
                end if;
            else
                rot_A_debounce_counter <= 0;
                rot_A_stable <= '0';
            end if;
        end if;
    end process;

    -- Debouncing process for "rot_B"
    process(clk, reset)
    begin
        if reset = '1' then
            rot_B_debounce_counter <= 0;
            rot_B_stable <= '0';
        elsif rising_edge(clk) then
            if rot_B = '1' then
                if rot_B_debounce_counter < DEBOUNCE_MAX then
                    rot_B_debounce_counter <= rot_B_debounce_counter + 1;
                else
                    rot_B_stable <= '1';
                end if;
            else
                rot_B_debounce_counter <= 0;
                rot_B_stable <= '0';
            end if;
        end if;
    end process;

    -- Main process to handle add/subtract logic and update 7-segment display
    process(clk, reset)
    begin
        if reset = '1' then
            count <= (others => '0');
            c_temp <= '0';
            tens_digit <= 0;
            ones_digit <= 0;
            value <= 0;
            last_encoder_A <= '0';
            debounce_flag <= '0';
        elsif rising_edge(clk) then
            -- Add/Subtract logic
            if rot_A_stable = '1' and debounce_flag = '0' and value < 99 then
                value <= value + 1;
                debounce_flag <= '1';
            elsif rot_B_stable = '1' and debounce_flag = '0' and value > 0 then
                value <= value - 1;
                debounce_flag <= '1';
            elsif rot_A_stable = '0' and rot_B_stable = '0' then
                debounce_flag <= '0';
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
