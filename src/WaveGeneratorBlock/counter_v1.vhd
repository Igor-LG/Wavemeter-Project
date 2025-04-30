-- This code defines a counter entity with a generic parameter N, which specifies the number of cycles.
-- The counter counts up to N-1 and then resets to 0.  
-- The counter output is a single bit that indicates when the counter has reached its maximum value (N-1).
-- The code is structured in a modular way, allowing for easy modification and reuse in different designs.

-- To obtain the pair f, 2f we just need to assign 2*N_cycles to the other module.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_v1 is
    generic (
        N_cycles : integer := 8  -- Example generic parameter
    );
    port (
        clk     : in  STD_LOGIC;  -- Clock input
        reset   : in  STD_LOGIC;  -- Reset input

        o_Tc    : out STD_LOGIC  -- Counter output
    );
end entity counter_v1;

architecture Behavioral of counter_v1 is

    signal counter_reg : integer range 0 to N_cycles-1 := 0; -- Internal counter register

begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                counter_reg <= 0; -- Reset counter to zero
            else
                if counter_reg = N_cycles-1 then
                    counter_reg <= 0; -- Reset counter when it reaches N_cycles-1
                    o_Tc <= '1'; -- Update output count
                else
                    counter_reg <= counter_reg + 1; -- Increment counter
                    o_Tc <= '0'; -- Update output count
                end if;
            end if;
        end if;
    end process;

end architecture Behavioral;
