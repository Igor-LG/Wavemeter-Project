-- Third version of the dual-port ROM for the sine table.
-- We store the values on and external package and we call it here.
-- We can modify the values in the package using a script in python.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--library work;
use work.rom_init_package.all;

entity sintableROM_vC is
    generic (
        DATA_WIDTH  : integer := 14;  -- Width of data --> output word
        ADDRESS_WIDTH  : integer := 5   -- Width of address --> table size = 2^ADDRESS_WIDTH
    );
    port (
		clk         : in std_logic;
		reset       : in std_logic;

        i_addr_a    : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);
        i_addr_b    : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);

        o_data_a    : out std_logic_vector(DATA_WIDTH-1 downto 0);
        o_data_b    : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity sintableROM_vC;

architecture Behavioral of sintableROM_vC is
		
    -- Output registers
    signal data_a_reg, data_b_reg : std_logic_vector(DATA_WIDTH-1 downto 0);

    -- Use the values from the package. CAUTION: DATA_WIDTH and ADDRESS_WIDTH must match the package values.
    signal myROM : rom_type := MEM_INIT;
	
begin

    -- Assign output
    o_data_a <= data_a_reg;
    o_data_b <= data_b_reg;

	process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                data_a_reg <= (others => '0');
                data_b_reg <= (others => '0');
            else
                data_a_reg <= myROM(to_integer(unsigned(i_addr_a)));
                data_b_reg <= myROM(to_integer(unsigned(i_addr_b)));
            end if;
        end if;
    end process;

end architecture Behavioral;
