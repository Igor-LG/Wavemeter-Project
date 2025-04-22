-- This code helps on the debugging using two signals that we can visualize: o_new_val and o_addr_end
-- --> o_new_val triggers every time a there is a new value of the ROM.
-- --> o_addr_end is triggered at the end of the address range of the ROM (1-period of the sinusoidal)
-- We can use this to check if the ROM is synchronized correctly.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity flagWatcher is
    generic (
        ADDRESS_WIDTH : integer := 8  -- Width of the wide input
    );
    port (
        clk         : in  std_logic;               -- Clock signal
        reset       : in  std_logic;               -- Reset signal

        i_Tc        : in  std_logic;               -- 1-bit input
        i_address   : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0); -- Address input

        o_new_val   : out std_logic;               -- 1-bit output (mirrors i_Tc)
        o_addr_end  : out std_logic                -- Trigger output on the last address
    );
end flagWatcher;

architecture Behavioral of flagWatcher is
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Reset outputs to default values
                o_new_val <= '0';
                o_addr_end <= '0';  -- Fixed the variable name here
            else
                -- Pass the 1-bit input to the 1-bit output
                o_new_val <= i_Tc;

                -- Check if the wide input is all '1's and set the trigger signal accordingly
                if i_address = (others => '1') then
                    o_addr_end <= '1';  -- Fixed the variable name here
                else
                    o_addr_end <= '0';
                end if;
            end if;
        end if;
    end process;

end Behavioral;
