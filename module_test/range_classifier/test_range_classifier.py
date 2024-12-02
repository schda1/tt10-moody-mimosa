# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.triggers import Timer

async def init(dut):
    dut._log.info("Start")
    dut.number_7bit.value = 0
    dut.out_bits_7bit.value = 0
    dut.number_10bit.value = 0
    dut.out_bits_10bit.value = 0
    await Timer(1, units='ns')

@cocotb.test()
async def test_range_classifier_7bit(dut):
    """
    Check whether 7-bit range classifier correctly classifies 
    0-31 as 0, 32-95 as 1 and 96-127 as 2. 
    """
    await init(dut)

    for number in range(127):

        number = number % 128

        dut.number_7bit.value = number
        await Timer(1, units='ns')

        if 0 <= number < 32:
            assert dut.out_bits_7bit == 0
        elif 32 <= number < 96:
            assert dut.out_bits_7bit == 1
        else:
            assert dut.out_bits_7bit == 2

@cocotb.test()
async def test_range_classifier_10bit(dut):
    """
    Check whether 10-bit range classifier correctly classifies 
    0-255 as 0, 256-767 as 1 and 768-1023 as 2. 
    """
    await init(dut)

    for number in range(2048):

        number = number % 1024

        dut.number_10bit.value = number
        await Timer(1, units='ns')

        if 0 <= number < 256:
            assert dut.out_bits_10bit == 0
        elif 256 <= number < 768:
            assert dut.out_bits_10bit == 1
        else:
            assert dut.out_bits_10bit == 2