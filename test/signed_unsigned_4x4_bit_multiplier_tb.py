# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

# signed_unsigned_4x4_bit_multiplier.py

import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def signed_unsigned_4x4_bit_multiplier(dut):

n = 4
    
for a in range(2**n):
	for b in range(2**n):
		dut.multiplicand.value = a
		dut.multiplier.value = b
		dut.signed_mode.value = 0
		await Timer(100, units="ns")
		dut._log.info("multiplicand = %s, multiplier = %s, product = %s", dut.multiplicand.value, dut.multiplier.value, dut.product.value)
    		assert dut.multiplicand.value*dut.multiplier.value == dut.product.value, "Unsigned multiplication failed."

for a in range(2**n):
	for b in range(2**n):
		dut.multiplicand.value = a-(2**(n-1))
		dut.multiplier.value = b-(2**(n-1))
		dut.signed_mode.value = 1
		await Timer(100, units="ns")
		dut._log.info("multiplicand = %s, multiplier = %s, product = %s", dut.multiplicand.value, dut.multiplier.value, dut.product.value)
    		assert dut.multiplicand.value*dut.multiplier.value == dut.product.value, "Signed multiplication failed."



