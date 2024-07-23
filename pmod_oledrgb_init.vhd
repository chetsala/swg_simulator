library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity OLEDrgb_init is
    Port (clk : in std_logic;
          rst : in std_logic;
          DC  : out std_logic;
          CS  : out std_logic;
          DIN : out std_logic;
          CLK : out std_logic);
end OLEDrgb_init;

-- oledrgb reference: https://digilent.com/reference/pmod/pmodoledrgb/reference-manual?redirect=1#quick_data_acquisition

architecture Behavioral of OLEDrgb_init is

    signal delay_cnt : integer range 0 to 100000000 := 0;

    procedure write_command_byte (data : std_logic_vector(7 downto 0)) is
    begin
        DC <= '0';
        CS <= '0';
        DIN <= data(7);
        CLK <= '0';
        CLK <= '1';
        for i in 6 downto 0 loop
            DIN <= data(i);
            CLK <= '0';
            CLK <= '1';
        end loop;
        CS <= '1';
    end write_command_byte;

begin

    process (clk, rst)
    begin
        if rst = '1' then
            DC <= '0';
            CS <= '0';
            DIN <= '0';
            CLK <= '0';
            delay_cnt <= 0;
        elsif rising_edge(clk) then
            if delay_cnt = 0 then
                write_command_byte(x"fd");
                delay_cnt <= 4000000; -- wait 40 ms
            elsif delay_cnt > 0 then
                delay_cnt <= delay_cnt - 1;
            end if;
        end if;
    end process;

end Behavioral;