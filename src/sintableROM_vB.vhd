-- Second version of the dual-port ROM for the sine table.
-- We store the values of the ROM directly in a constant array.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sintableROM_vB is
    generic (
        DATA_WIDTH  : integer := 14;  -- Width of data --> output word
        ADDR_WIDTH  : integer := 5   -- Width of address --> table size = 2^ADDR_WIDTH
    );
    port (
		clk         : in std_logic;
		reset       : in std_logic;

        i_addr_a    : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        i_addr_b    : in  std_logic_vector(ADDR_WIDTH-1 downto 0);

        o_data_a    : out std_logic_vector(DATA_WIDTH-1 downto 0);
        o_data_b    : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity sintableROM_vB;

architecture Behavioral of sintableROM_vB is
	
	-- >>>>> TYPES DECLARED <<<<<
    -- Declare the ROM memory type
    type rom_type is array (0 to (2**ADDR_WIDTH)-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
	
	-- >>>>> SIGNALS <<<<<
    -- Output registers
    signal data_a_reg, data_b_reg : std_logic_vector(DATA_WIDTH-1 downto 0);

    -- Declare the values for the ROM
	constant myROM : rom_type := (
		0	=> "10000000000000",
		1	=> "10011001000000",
		2	=> "10110010000000",
		3	=> "11001000000000",
		4	=> "11011100000000",
		5	=> "11101100000000",
		6	=> "11110111000000",
		7	=> "11111110000000",
		8	=> "11111111000000",
		9	=> "11111011000000",
		10	=> "11110010000000",
		11	=> "11100100000000",
		12	=> "11010011000000",
		13	=> "10111101000000",
		14	=> "10100110000000",
		15	=> "10001100000000",
		16	=> "01110011000000",
		17	=> "01011001000000",
		18	=> "01000010000000",
		19	=> "00101100000000",
		20	=> "00011011000000",
		21	=> "00001101000000",
		22	=> "00000100000000",
		23	=> "00000000000000",
		24	=> "00000001000000",
		25	=> "00001000000000",
		26	=> "00010011000000",
		27	=> "00100011000000",
		28	=> "00110111000000",
		29	=> "01001101000000",
		30	=> "01100110000000",
		31	=> "01111111000000"
		);

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
