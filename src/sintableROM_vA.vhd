-- First version of the dual-port ROM for the sine table.
-- We write an inferred ROM and initialize it with a .mif file according to the Quartus manual's instructions.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sintableROM_vA is
    generic (
        DATA_WIDTH  : integer := 14;  -- Width of data --> output word
        ADDR_WIDTH  : integer := 5   -- Width of address --> table size = 2^ADDR_WIDTH
    );
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;

        i_addr_a    : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        i_addr_b    : in  std_logic_vector(ADDR_WIDTH-1 downto 0);

        o_data_a    : out std_logic_vector(DATA_WIDTH-1 downto 0);
        o_data_b    : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture Behavioral of sintableROM_vA is

    -- Declare the ROM memory type
    type rom_type is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);

    -- Declare the ROM signal
    signal myROM : rom_type;

    -- Output registers
    signal data_a_reg, data_b_reg : std_logic_vector(DATA_WIDTH-1 downto 0);

    -- Attach external .mif file
    attribute ram_init_file : string;
    attribute ram_init_file of myROM : signal is "rom_init.mif";

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
