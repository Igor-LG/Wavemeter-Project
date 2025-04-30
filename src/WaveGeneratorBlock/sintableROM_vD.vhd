-- Fourth version of the dual-port ROM for the sine table.
-- We have the values stored in a text file and we read them using textio package.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity sintableROM_vD is
    generic(
        DATA_WIDTH  : integer := 14;  -- Width of data --> output word
        ADDRESS_WIDTH  : integer := 5   -- Width of address --> table size = 2^ADDRESS_WIDTH
    );
    port(
		clk		    : in std_logic;
		reset   	: in std_logic;

        i_addr_a    : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);
        i_addr_b    : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);

        o_data_a    : out std_logic_vector(DATA_WIDTH-1 downto 0);
        o_data_b    : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity sintableROM_vD;

architecture Behavioral of sintableROM_vD is
	
	-- >>>>> TYPES DECLARED <<<<<
    -- For the LUT
    type rom_type is array (0 to (2**ADDRESS_WIDTH)-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
	

	-- >>>>> FUNCTIONS <<<<<
	-- 1) Loading file data into the FPGA - VHDL-2008
	impure function load_rom_from_hex return rom_type is
		file text_file : text open read_mode is "path_to_your_file.txt"; -- Change this to your file path
		variable text_line : line;
		variable rom_content : rom_type;
	begin
	
		for i in 0 to 2**ADDRESS_WIDTH - 1 loop
			readline(text_file, text_line);
			hread(text_line, rom_content(i));
		end loop;

		return rom_content;
		
	end function;
	
	-- 2) Loading file data into the FPGA - VHDL-2002
	impure function load_rom_from_hex_VHDL2002 return rom_type is
		file text_file			: text open read_mode is "path_to_your_file.txt"; -- Change this to your file path
		variable text_line		: line;
		variable rom_content	: rom_type;
		variable c				: character;
		variable offset			: integer;
		variable hex_val		: std_logic_vector(3 downto 0);
	begin
	
		for i in 0 to 2**ADDRESS_WIDTH - 1 loop
			readline(text_file, text_line);
	
			offset := 0;
	
			while offset < rom_content(i)'high loop
				read(text_line, c);
	
				case c is
					when '0' => hex_val := "0000";
					when '1' => hex_val := "0001";
					when '2' => hex_val := "0010";
					when '3' => hex_val := "0011";
					when '4' => hex_val := "0100";
					when '5' => hex_val := "0101";
					when '6' => hex_val := "0110";
					when '7' => hex_val := "0111";
					when '8' => hex_val := "1000";
					when '9' => hex_val := "1001";
					when 'A' | 'a' => hex_val := "1010";
					when 'B' | 'b' => hex_val := "1011";
					when 'C' | 'c' => hex_val := "1100";
					when 'D' | 'd' => hex_val := "1101";
					when 'E' | 'e' => hex_val := "1110";
					when 'F' | 'f' => hex_val := "1111";
	
					when others =>
						hex_val := "XXXX";
						assert false report "Found non-hex character '" & c & "'";
				end case;
	
				rom_content(i)(rom_content(i)'high - offset
					downto rom_content(i)'high - offset - 3) := hex_val;
				offset := offset + 4;
			end loop;
		end loop;
		
		return rom_content;
		
	end function;


	-- >>>>> SIGNALS <<<<<
    -- Output registers
    signal data_a_reg, data_b_reg : std_logic_vector(DATA_WIDTH-1 downto 0);
    
    -- Initialize RAM from hex values in ASCII file
	signal myROM : rom_type := load_ram_from_hex;
	

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
