-- Full_adder used as carry_sum_adder or ripple-carry adder

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