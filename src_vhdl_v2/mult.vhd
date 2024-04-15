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
	
end rtl;-- Tiny Tapeout Signed/unsigned nxn-bit multiplier

-- 4-bit signed/unsigned multiplicand
-- 4-bit signed/unsigned multiplier
-- 8-bit signed/unsigned product
-- Signed_mode selects data type for both operands and result

-- The unsigned combinational multiplier uses an nxn array of full-adders that add product bits
-- and a final stage of ripple-carry full-adders for the upper half of the product.

-- The multiplier above is extended to signed (2's complement) numbers by employing the
-- Modified Baugh-Wooley multiplication algorithm, which avoids sign-extension by flipping product
-- bits in MSB positions of both operands (cancel out for cell that combine MSBs of both operands),
-- and adding ones at the least and most significant bit positions of the final ripple-carry adder.

library ieee;
use ieee.std_logic_1164.all;

entity signed_unsigned_nxn_bit_multiplier is
	generic (n : integer);
	port (
		multiplicand	: in std_logic_vector(n-1 downto 0);
		multiplier		: in std_logic_vector(n-1 downto 0);
		signed_mode		: in std_logic;
		product			: out std_logic_vector(2*n-1 downto 0));
end signed_unsigned_nxn_bit_multiplier;

architecture rtl of signed_unsigned_nxn_bit_multiplier is

	component full_adder
	port (
		a			: in std_logic;
		b			: in std_logic;
		c			: in std_logic;
		sum_out	: out std_logic;
		carry_out: out std_logic);
	end component;

	type signal_array is array (n-1 downto 0) of std_logic_vector(n-1 downto 0);
	type extd_signal_array is array (n-1 downto 0) of std_logic_vector(n downto 0);
	signal part_prod_sum : extd_signal_array;
	signal part_prod_carry : signal_array;
	signal product_bit, invert : signal_array;
	signal ripple_carry : std_logic_vector(2*n downto n);

begin

	multiplier_bits: for i in 0 to n-1 generate

		-- Left column of 0's and for signed mode a single '1'
		part_prod_sum(i)(n) <= '1' when i = n-1 and signed_mode = '1' else '0';
		
		multiplicand_bits: for j in 0 to n-1 generate
			invert(i)(j) <= '1' when (i=n-1 xor j=n-1) and signed_mode = '1' else '0';
			product_bit(i)(j) <= '1' when (multiplicand(j) = '1' and multiplier(i) = '1') xor invert(i)(j) = '1' else '0';
			cell: if i = 0 generate
				carry_save_adder_bit: full_adder port map (
					a => '0',
					b => '0',
					c => product_bit(i)(j),
					sum_out => part_prod_sum(i)(j),
					carry_out => part_prod_carry(i)(j));
			else generate
				carry_save_adder_bit: full_adder port map (
					a => part_prod_sum(i-1)(j+1),
					b => part_prod_carry(i-1)(j),
					c => product_bit(i)(j),
					sum_out => part_prod_sum(i)(j),
					carry_out => part_prod_carry(i)(j));
			end generate cell;
		end generate multiplicand_bits;
	end generate multiplier_bits;

	lower_product_bits: for i in 0 to n-1 generate
		product(i) <= part_prod_sum(i)(0);
	end generate;

	ripple_carry(n) <= '1' when signed_mode = '1' else '0';

	upper_product_bits: for j in 0 to n-1 generate
		ripple_adder_bit: full_adder port map (
			a => part_prod_sum(n-1)(j+1),
			b => part_prod_carry(n-1)(j),
			c => ripple_carry(n+j),
			sum_out => product(n+j),
			carry_out => ripple_carry(n+j+1));
	end generate;

end rtl;-- Full_adder used as carry_sum_adder or ripple-carry adder

library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
	port (
		a			: in std_logic;
		b			: in std_logic;
		c			: in std_logic;
		sum_out	: out std_logic;
		carry_out: out std_logic);
end full_adder;

architecture rtl of full_adder is

begin

	sum_out	 <= a xor b xor c;
	carry_out <= (a and b) or (a and c) or (b and c);

end rtl;