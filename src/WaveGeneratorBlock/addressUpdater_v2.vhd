-- This code updates an address output based on an enable signal.
-- The output is inside a process statement to ensure synchronous behavior with the global clock.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity addressUpdater_v2 is
    generic (
        ADDRESS_WIDTH : integer := 14  -- Generic parameter for output width
    );
    port (
        clk             : in  std_logic; -- Clock input
        reset           : in  std_logic; -- reset input
        enable_update   : in  std_logic; -- 1-bit input port

        o_address       : out std_logic_vector(ADDRESS_WIDTH-1 downto 0)  -- Output address with width defined by generic
    );
end addressUpdater_v2;

architecture Behavioral of addressUpdater_v2 is
        
        signal address_reg      : UNSIGNED(ADDRESS_WIDTH-1 downto 0) := (others => '0'); -- Internal register
        constant max_address    : UNSIGNED(ADDRESS_WIDTH-1 downto 0) := (others => '1'); -- Maximum address value
begin

    -- Assign the internal register to the output using a process to ensure synchronous behavior
    process(clk)
    begin
        if rising_edge(clk) then
            o_address <= std_logic_vector(address_reg);  
        end if;
    end process;

    -- Update output whenever enable_update changes
    process(enable_update)
    begin
        if reset = '1' then
            address_reg <= (others => '0');  -- Reset output to all zeros
        else 
            if address_reg = max_address then
                address_reg <= (others => '0');  -- Reset output to all zeros when max address is reached
            else
                address_reg <= address_reg + 1;  -- Increment the address register
            end if;
        end if;
    end process;  

end architecture Behavioral;
