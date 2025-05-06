library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity TB_WaveGeneratorBlock is
end entity TB_WaveGeneratorBlock;

architecture sim of TB_WaveGeneratorBlock is
	
	constant ClockFrequencyHz	: integer := 1000; -- f = 1000 Hz
	constant ClockPeriod		: time := 1000 ms / ClockFrequencyHz; -- T = 1 ms
	
	constant DATA_WIDTH     : integer := 14;
	constant ADDRESS_WIDTH	: integer := 5;
	constant N_cycles   	: integer := 4; -- For stablishing the frequency. Later W2 will be W1/2.
	
	signal Clk	: std_logic := '1';
	signal Rst	: std_logic := '0';
	
	signal o_data_W1	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal o_LUTend_W1	: std_logic;
	signal o_TC_W1		: std_logic;

    signal o_data_W2	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal o_LUTend_W2	: std_logic;
	signal o_TC_W2		: std_logic;
	
begin
	
    -- Process for generating the ClockFrequency
	Clk <= not Clk after ClockPeriod / 2;

	-- The DUT
	SIN_GENERATOR : entity work.top_WaveGeneratorBlock(Behavioral)
		generic map(
			DATA_WIDTH		=> DATA_WIDTH,
			ADDRESS_WIDTH	=> ADDRESS_WIDTH,
			N_cycles_W1		=> N_cycles,
            N_cycles_W2		=> N_cycles/2
		)
		port map(
			clk 		=> Clk,
			reset		=> Rst,
			o_data_W1	=> o_data_W1,
			o_data_W2   => o_data_W2,
			o_LUTend_W1 => o_LUTend_W1,
            o_LUTend_W2 => o_LUTend_W2,
            o_TC_W1	    => o_TC_W1,
            o_TC_W2	    => o_TC_W2
		);
	
	-- Testbench stimulus 1: Start after reset with reset signal not in exactly in clock synchronization
	process is
	begin
		Rst <= '1';
		wait for 11 * ClockPeriod/2; -- ~5.5 clockperiods
		Rst <= '0';
		wait for 587 * ClockPeriod/10; -- ~58.7 clockperiods
		Rst <= '1';
		wait for 5 * ClockPeriod/2; -- ~2.5 clockperiods
		Rst <= '0';
		wait for 20000* ClockPeriod; --
	end process;
	
	-- Testbench stimulus 2: Start after reset with reset signal synchronize with clock
	--process is
	--begin
	--	Rst <= '1';
	--	wait for 5 * ClockPeriod; -- ~5.5 clockperiods
	--	Rst <= '0';
	--	wait for 58 * ClockPeriod; -- ~58.7 clockperiods
	--	Rst <= '1';
	--	wait for 5 * ClockPeriod; -- ~2.5 clockperiods
	--	Rst <= '0';
	--	wait for 200* ClockPeriod; --
	--end process;
	
	-- Testbench stimulus 3: Start directly
	--process is
	--begin
	--	Rst <= '0';
	--	wait for  50 * ClockPeriod;
	--	Rst <= '1';
	--	wait for 5 * ClockPeriod;
	--	Rst <= '0';
	--	wait for 100 * ClockPeriod;
	--	Rst <= '1';
	--	wait for 5 * ClockPeriod;
	--end process;
	
	-- Testbench stimulus 3
	--process is
	--begin
	--	Rst <= '0';
	--	wait for 5 * ClockPeriod;
	--	Rst <= '1';
	--	wait for 2 * ClockPeriod;
	--	Rst <= '0';
	--	wait for 35 * ClockPeriod;
	--	Rst <= '1';
	--	wait for 5 * ClockPeriod;
	--	Rst <= '0';
	--	wait for 2 * ClockPeriod;
	--	Rst <= '1';
	--	wait for 1 * ClockPeriod;
	--end process;
	
end architecture;