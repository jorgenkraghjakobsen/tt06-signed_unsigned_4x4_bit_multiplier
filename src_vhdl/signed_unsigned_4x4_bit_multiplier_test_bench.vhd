-- Tiny Tapeout Signed/unsigned 4x4-bit multiplier test bench

-- 4-bit signed/unsigned multiplicand
-- 4-bit signed/unsigned multiplier
-- 8-bit signed/unsigned product
-- Signed_mode selects data type for both operands and result

-- Top level

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signed_unsigned_4x4_bit_multiplier_test_bench is
	
end signed_unsigned_4x4_bit_multiplier_test_bench;

architecture rtl of signed_unsigned_4x4_bit_multiplier_test_bench is

	component signed_unsigned_nxn_bit_multiplier
	generic (n : integer);
	port (
		multiplicand: in std_logic_vector(n-1 downto 0);
		multiplier	: in std_logic_vector(n-1 downto 0);
		signed_mode	: in std_logic;
		product		: out std_logic_vector(2*n-1 downto 0));
	end component;

	constant	n : integer := 4;

	signal multiplicand, multiplier : std_logic_vector(n-1 downto 0);
	signal product : std_logic_vector(2*n-1 downto 0);
	signal signed_mode : std_logic;

begin

	dut: signed_unsigned_nxn_bit_multiplier
		generic map (n => n)
		port map (
			multiplicand	=> multiplicand,
			multiplier		=> multiplier,
			signed_mode		=> signed_mode,
			product			=> product);

	test : process is
	
		variable c : integer;

	begin

		-- Test unsigned mode

		for a in 0 to 2**n-1 loop
			for b in 0 to 2**n-1 loop
				multiplicand <= std_logic_vector(to_unsigned(a, multiplicand'length));
				multiplier   <= std_logic_vector(to_unsigned(b, multiplier'length));
				signed_mode  <= '0';
				c := to_integer(unsigned(product));
				assert a*b = c report "Unsigned multiply failed";
				wait for 100 ns;
			end loop;
		end loop;

		-- Test signed mode

		for a in -2**(n-1) to 2**(n-1)-1 loop
			for b in -2**(n-1) to 2**(n-1)-1 loop
				multiplicand <= std_logic_vector(to_signed(a, multiplicand'length));
				multiplier   <= std_logic_vector(to_signed(b, multiplier'length));
				signed_mode  <= '1';
				c := to_integer(signed(product));
				assert a*b = c report "Signed multiply failed";
				wait for 100 ns;
			end loop;
		end loop;

		wait;
	end process test;

end rtl;