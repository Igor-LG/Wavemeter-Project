-- This is a pwm with 50% duty cycle so that it can be used to interface with address updater.
-- To avoid problems the number_of_cycles should be a power of 2 number.
-- The equation for the increment is as follows:
-- --> incr_i = 2^(bit_width) / number_of_cycles
-- The equation for the frequency is as follows:
-- --> freq = clk_freq / incr_i

-- In our case we have: bit_width = 32, number_of_cycles = 2 ==> incr_i = 2^(32) / 2 = 0x80000000
-- To get the par f, 2f the next module should be: bit_width = 32, number_of_cycles = 4 ==> incr_i = 2^(32) / 4 = 0x40000000


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_v2 is
    Port (
        clk             : in STD_LOGIC; -- Clock input
        reset           : in STD_LOGIC; -- Reset input
        incr_i          : in STD_LOGIC_VECTOR (31 downto 0) := X"80000000"; -- Default increment value to get max frequency
        duty_cycle_i    : in STD_LOGIC_VECTOR (31 downto 0) := X"80000000"; -- Default value of 50% for duty cycle

        o_Tc            : out STD_LOGIC -- PWM output signal as counter output
    );
end counter_v2;

architecture Behavioral of counter_v2 is

     signal counter_reg : UNSIGNED(31 downto 0);

begin

    process(clk)
    begin 
        if rising_edge(clk) then
            if reset = '1' then
                counter_reg <= (others => '0');
            else
                counter_reg <= counter_reg + UNSIGNED(incr_i);
            end if;
        end if;
    end process;
    
    o_Tc <= '1' when counter_reg < UNSIGNED(duty_cycle_i) else '0';
    
end architecture Behavioral;
