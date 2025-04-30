-- This code updates an address output based on an enable signal.
-- On each clock cycle, if the enable signal is high, the address is incremented.
-- If the address reaches a maximum value, it resets to zero.
-- The design is parameterized to allow for different output widths.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity addressUpdater_v1 is
    generic (
        ADDRESS_WIDTH : integer := 5  -- Generic parameter for address width
    );
    port (
        clk               : in  std_logic;    -- Clock input
        reset             : in  std_logic;    -- Synchronous reset input
        i_enable_update   : in  std_logic;    -- Enable signal for address update
        
        o_address         : out std_logic_vector(ADDRESS_WIDTH-1 downto 0)  -- Output address with width defined by generic
    );
end addressUpdater_v1;

architecture Behavioral of addressUpdater_v1 is
    
    signal address_reg      : UNSIGNED(ADDRESS_WIDTH-1 downto 0) := (others => '0'); -- Internal register
    constant max_address    : UNSIGNED(ADDRESS_WIDTH-1 downto 0) := (others => '1'); -- Maximum address value

begin

    -- Assign the internal register to the output
    o_address <= std_logic_vector(address_reg);  

    -- Process with synchronous reset
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                address_reg <= (others => '0');  -- Reset output to all zeros
            else
                if i_enable_update = '1' then  -- Check if update is enabled
                    if address_reg = max_address then
                        address_reg <= (others => '0');  -- Reset output to all zeros when max address is reached
                    else
                        address_reg <= address_reg + 1;  -- Increment the address register
                    end if;
                end if;
            end if;
        end if;
    end process;

end architecture Behavioral;
