-- Tiny Tapeout Signed/unsigned 8x8-bit multiplier test

-- 4-bit signed/unsigned multiplicand
-- 4-bit signed/unsigned multiplier
-- 8-bit signed/unsigned product
-- Signed_mode selects data type for both operands and result

-- Top level

library ieee;
use ieee.std_logic_1164.all;

entity signed_unsigned_8x8_bit_multiplier_test is
	port (
		product		: out std_logic_vector(15 downto 0));
end signed_unsigned_8x8_bit_multiplier_test;

architecture rtl of signed_unsigned_8x8_bit_multiplier_test is

	component signed_unsigned_nxn_bit_multiplier
	generic (n : integer);
	port (
		multiplicand: in std_logic_vector(n-1 downto 0);
		multiplier	: in std_logic_vector(n-1 downto 0);
		signed_mode	: in std_logic;
		product		: out std_logic_vector(2*n-1 downto 0));
	end component;

	constant	n : integer := 8;

begin

	test: signed_unsigned_nxn_bit_multiplier
		generic map (n => n)
		port map (
		
--			multiplicand	=> b"00000000", --    0 decimal
--			multiplier		=> b"00000000", --    0 decimal
--			signed_mode		=> '0',			 -- Unsigned multiply
--			product			=> product);	 -- 0000 hexadecimal		
		
--			multiplicand	=> b"00001111", --   15 decimal
--			multiplier		=> b"01010001", --   81 decimal
--			signed_mode		=> '0',			 -- Unsigned multiply
--			product			=> product);	 -- 74BF hexadecimal
			
--			multiplicand	=> b"11111111", --  255 decimal
--			multiplier		=> b"11010001", --  209 decimal
--			signed_mode		=> '0',			 -- Unsigned multiply
--			product			=> product);	 -- D02F hexadecimal			
		
			multiplicand	=> b"00001111", --   15 decimal
			multiplier		=> b"01010001", --   81 decimal
			signed_mode		=> '1',			 -- Signed multiply
			product			=> product);	 -- 04BF hexadecimal

--			multiplicand	=> b"00001111", --   15 decimal
--			multiplier		=> b"11010001", --  -47 decimal
--			signed_mode		=> '1',			 -- Signed multiply
--			product			=> product);	 -- FD3F hexadecimal
--			
--			multiplicand	=> b"10001111", -- -113 decimal
--			multiplier		=> b"01010001", --   81 decimal
--			signed_mode		=> '1',			 -- Signed multiply
--			product			=> product);	 -- DC3F hexadecimal

--			multiplicand	=> b"10001111", -- -113 decimal
--			multiplier		=> b"11010001", --  -47 decimal
--			signed_mode		=> '1',			 -- Signed multiply
--			product			=> product);	 -- 14BF hexadecimal

end rtl;