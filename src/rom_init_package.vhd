-- Package to initialize the ROM with custom values in hexadecimal.
-- To change the values we only need to create a script in python that generates the structure below with the desired.
-- CAUTION! Pay attention to the number of words and the word's length!

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package rom_init_package is
  
    -- This can be customized. Now = 2^5 x 14
    type rom_type is array (0 to (2**5)-1) of std_logic_vector(14-1 downto 0);
    
    -- This can be customized.
    constant MEM_INIT : rom_type := (
        x"2000",
        x"26B0",
        x"2C9E",
        x"3287",
        x"3871",
        x"3B27",
        x"3E01",
        x"3FA1",
        x"3FDC",
        x"3EFA",
        x"3D7A",
        x"394D",
        x"3617",
        x"3207",
        x"2994",
        x"2334",
        x"0EB3",
        x"096B",
        x"0458",
        x"02D0",
        x"01B2",
        x"00D5",
        x"0045",
        x"000B",
        x"005E",
        x"01FE",
        x"0278",
        x"046E",
        x"06D8",
        x"09A9",
        x"0D0F",
        x"0FFF"
    );
    
  end package rom_init_package;