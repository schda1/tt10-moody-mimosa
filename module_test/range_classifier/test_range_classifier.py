# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.triggers import Timer

async def init(dut):
    dut._log.info("Start")
    dut.number.value = 0
    dut.out_bits.value = 0
    await Timer(1, units='ns')

@cocotb.test()
async def test_range_classifier(dut):
    """
    Check whether range classifier correctly classifies 
    0-31 as 0, 32-95 as 1 and 96-127 as 2. 
    """
    await init(dut)

    for number in range(127):

        number = number % 128

        dut.number.value = number
        await Timer(1, units='ns')

        if 0 <= number < 32:
            assert dut.out_bits == 0
        elif 32 <= number < 96:
            assert dut.out_bits == 1
        else:
            assert dut.out_bits == 2
