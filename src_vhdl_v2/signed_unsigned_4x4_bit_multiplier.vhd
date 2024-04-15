-- Tiny Tapeout Signed/unsigned 4x4-bit multiplier

-- 4-bit signed/unsigned multiplicand
-- 4-bit signed/unsigned multiplier
-- 8-bit signed/unsigned product
-- Signed_mode selects data type for both operands and result

-- Top level

library ieee;
use ieee.std_logic_1164.all;

entity signed_unsigned_4x4_bit_multiplier is
	port (
		multiplicand: in  std_logic_vector(3 downto 0);
		multiplier  : in  std_logic_vector(3 downto 0);
		signed_mode : in  std_logic;
		product		: out std_logic_vector(7 downto 0));
end signed_unsigned_4x4_bit_multiplier;

architecture rtl of signed_unsigned_4x4_bit_multiplier is

	component signed_unsigned_nxn_bit_multiplier
	generic (n : integer);
	port (
		multiplicand: in std_logic_vector(n-1 downto 0);
		multiplier	: in std_logic_vector(n-1 downto 0);
		signed_mode	: in std_logic;
		product		: out std_logic_vector(2*n-1 downto 0));
	end component;

	constant	n : integer := 4;

begin

	multiply : signed_unsigned_nxn_bit_multiplier
		generic map (4)
		port map (		
			multiplicand	=> multiplicand,
			multiplier		=> multiplier,
			signed_mode		=> signed_mode,
			product			=> product);
	
end rtl;