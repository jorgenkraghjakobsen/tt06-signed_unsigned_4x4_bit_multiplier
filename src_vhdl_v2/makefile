TOP = signed_unsigned_4x4_bit_multiplier

convert:
	vhd2vl full_adder.vhd > full_adder.v ;\
	vhd2vl signed_unsigned_4x4_bit_multiplier.vhd > signed_unsigned_4x4_bit_multiplier.v ;\
	vhd2vl signed_unsigned_nxn_bit_multiplier.vhd > signed_unsigned_nxn_bit_multiplier.v 
	
combine:
	cat signed_unsigned_4x4_bit_multiplier.vhd > mult.vhd  ;\
	cat signed_unsigned_nxn_bit_multiplier.vhd >> mult.vhd ;\
	cat full_adder.vhd >> mult.vhd 
	
synth:
	yosys -m ghdl.so -p 'ghdl --std=08 mult.vhd -e $(TOP) ; write_verilog $(TOP).v'
