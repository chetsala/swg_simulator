library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SWG_SYS is
    Port ( clk      : in  STD_LOGIC;
           value       : in  STD_LOGIC_VECTOR (3 downto 0);
           reset : in std_logic;  -- Reset input
           BTN   : in STD_LOGIC_VECTOR (1 downto 0); --  BTN1 at position 0, BTN2 at position 1
           ssd_display  : out STD_LOGIC_VECTOR (6 downto 0);
           c : out STD_LOGIC);
end SWG_SYS;

architecture behavioral of SWG_SYS is

    signal tens_digit, ones_digit : integer range 0 to 9;
    signal count : unsigned(16 - 1 downto 0); -- alternating between digits
    signal c_temp : std_logic; -- temp var since "out" ports cannot be read in
    signal saved_value : integer range 0 to 99 := 0;  -- signal to store the saved value
    signal display_value : integer range 0 to 99 := 0; -- current value to be displayed

begin

    process (clk, reset)
        begin
        if reset = '1' then
            count <= (others => '0');
            c_temp <= '0';
            tens_digit <= 0;
            ones_digit <= 0;
            saved_value <= 0;
            display_value <= 0;
        elsif rising_edge(clk) then
            count <= count + 1;

            -- Convert to BCD
      tens_digit <= TO_INTEGER(unsigned(value)) / 10; -- use when value == switches
      ones_digit <= TO_INTEGER(unsigned(value)) mod 10; -- use when value == switches
      --tens_digit <= value / 10; -- use when value == integer
      --ones_digit <= value mod 10; -- use when value == integer

            -- Button presses
      if BTN(0) = '1' then -- BTN1 pressed
        saved_value <= TO_INTEGER(unsigned(value));
      elsif BTN(1) = '1' then -- BTN2 pressed
        display_value <= saved_value;
      else
        display_value <= TO_INTEGER(unsigned(value));
      end if;
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

