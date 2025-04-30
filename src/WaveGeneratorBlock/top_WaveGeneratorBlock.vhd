library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top_WaveGeneratorBlock is
    generic(
        DATA_WIDTH      : integer := 14;  -- Width of data --> output word
        ADDRESS_WIDTH   : integer := 5;   -- Width of address --> table size = 2^ADDRESS_WIDTH

		N_cycles_W1	: integer := 20;  -- For stablishing the frequency W1
        N_cycles_W2	: integer := 10  -- For stablishing the frequency W2, being W2 = 2*W1 => N_cycles_W2 = N_cycles_W1/2
    );
    port(
		clk			: in std_logic;
		reset		: in std_logic;

		o_data_W1   : out std_logic_vector(DATA_WIDTH-1 downto 0);
        o_data_W2	: out std_logic_vector(DATA_WIDTH-1 downto 0);

		-- Control SIGNALS
		o_LUTend_W1	: out std_logic; -- trigger signal activated at the end of period for frequency W1
        o_LUTend_W2	: out std_logic; -- trigger signal activated at the end of period for frequency W2

		o_TC_w1		: out std_logic; -- trigger signal activated on every new value of the LUT for W1
        o_TC_w2		: out std_logic; -- trigger signal activated on every new value of the LUT for W2

		-- Differential clock for D/A
		o_clk_diff  : out std_logic
    );
end entity top_WaveGeneratorBlock;

architecture Behavioral of top_WaveGeneratorBlock is

    signal o_TC_w1_reg : std_logic;
    signal o_TC_w2_reg : std_logic;

	signal address_W1_reg : std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    signal address_W2_reg : std_logic_vector(ADDRESS_WIDTH-1 downto 0);

begin

	-- Creating the differential clock
	o_clk_diff <= clk; 

    -- Counter, address updater and flag watcher for W1
    COUNTER_W1 : entity work.counter_v1(Behavioral)
        generic map(
            N_cycles => N_cycles_W1
        )
        port map(
            clk 			=> clk,
            reset			=> reset,
            o_TC			=> o_TC_w1_reg
        );

    ADDRESS_UPDATER_W1 : entity work.addressUpdater_v1(Behavioral)
        generic map(
            ADDRESS_WIDTH => ADDRESS_WIDTH
        )
        port map(
            clk 			=> clk,
            reset			=> reset,
            i_enable_update	=> o_TC_w1_reg,
            o_address		=> address_W1_reg
        );

    FLAG_WATCHER_W1 : entity work.flagWatcher(Behavioral)
        generic map(
            ADDRESS_WIDTH => ADDRESS_WIDTH
        )
        port map(
            clk 		=> clk,
            reset		=> reset,
            i_TC        => o_TC_w1_reg,
            i_address   => address_W1_reg,
            o_new_val	=> o_TC_w1,
            o_addr_end	=> o_LUTend_W1
        );


    -- Counter, address updater and flag watcher for W2
    COUNTER_W2 : entity work.counter_v1(Behavioral)
        generic map(
            N_cycles => N_cycles_W2
        )
        port map(
            clk 			=> clk,
            reset			=> reset,
            o_TC			=> o_TC_w2_reg
        );

    ADDRESS_UPDATER_W2 : entity work.addressUpdater_v1(Behavioral)
        generic map(
            ADDRESS_WIDTH => ADDRESS_WIDTH
        )
        port map(
            clk 			=> clk,
            reset			=> reset,
            i_enable_update	=> o_TC_w2_reg,
            o_address		=> address_W2_reg
        );

    FLAG_WATCHER_W2 : entity work.flagWatcher(Behavioral)
        generic map(
            ADDRESS_WIDTH => ADDRESS_WIDTH
        )
        port map(
            clk 		=> clk,
            reset		=> reset,
            i_TC	    => o_TC_w2_reg,
            i_address	=> address_W2_reg,
            o_new_val	=> o_TC_w2,
            o_addr_end	=> o_LUTend_W2
        );

    
    -- ROM instantiations for W1 and W2
    SINTABLE : entity work.sintableROM_vC(Behavioral)
        generic map(
            DATA_WIDTH      => DATA_WIDTH,
            ADDRESS_WIDTH   => ADDRESS_WIDTH
        )
        port map(
            clk         => clk,
            reset       => reset,
            i_addr_a    => address_W1_reg,
            i_addr_b    => address_W2_reg,
            o_data_a    => o_data_W1,
            o_data_b    => o_data_W2
        );

end architecture Behavioral;
