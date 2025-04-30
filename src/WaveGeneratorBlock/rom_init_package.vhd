-- Package to initialize the ROM with custom values in hexadecimal.
-- To change the values we only need to create a script in python that generates the structure below with the desired.
-- CAUTION! Pay attention to the number of words and the word's length!

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package rom_init_package is
  
    -- This can be customized. Now = 2**5 x 14
    type rom_type is array (0 to (2**5)-1) of std_logic_vector(14-1 downto 0);
    
    -- This can be customized.
    constant MEM_INIT : rom_type := (
        "10000000000000", "10011001110000", "10110010011110", "11001001000111",
        "11011100110001", "11101100100111", "11111000000001", "11111110100001",
        "11111111110100", "11111011111010", "11110010111010", "11100101001101",
        "11010011010111", "10111110000111", "10100110010100", "10001100111100",
        "01110011000011", "01011001101011", "01000001111000", "00101100101000",
        "00011010110010", "00001101000101", "00000100000101", "00000000001011",
        "00000001011110", "00000111111110", "00010011011000", "00100011001110",
        "00110110111000", "01001101100001", "01100110001111", "01111111111111"
    );
    
  end package rom_init_package;