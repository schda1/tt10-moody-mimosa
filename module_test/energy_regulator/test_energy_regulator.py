# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.triggers import Timer
from itertools import product

async def init(dut):
    dut._log.info("Start")
    dut.state_controller_inc.value = 0
    dut.state_controller_dec.value = 0
    await Timer(1, units='ns')

@cocotb.test()
async def test_energy_regulator(dut):
    """
    Check all combinations
            """
    await init(dut)

    for inc, dec in product([0, 1], repeat=2):
        dut.state_controller_inc.value = inc
        dut.state_controller_dec.value = dec
        await Timer(1, units='ns')
        assert dut.energy_inc.value == inc
        assert dut.energy_dec.value == dec