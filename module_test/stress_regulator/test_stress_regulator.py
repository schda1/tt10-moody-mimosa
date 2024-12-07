# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.triggers import Timer
from itertools import product

async def init(dut):
    dut._log.info("Start")
    dut.sleep_controller_inc.value = 0
    dut.sleep_controller_dec.value = 0
    dut.stimuli.value = 0
    await Timer(1, units='ns')

@cocotb.test()
async def test_stress_regulator_no_stimuli(dut):
    """
    Check all combinations without external stimuli
    """
    await init(dut)

    dut.stimuli.value = 0

    for inc, dec in product([0, 1], repeat=2):
        dut.sleep_controller_inc.value = inc
        dut.sleep_controller_dec.value = dec
        await Timer(1, units='ns')
        assert dut.stress_inc.value == inc
        assert dut.stress_dec.value == dec

@cocotb.test()
async def test_stress_regulator_with_stimuli(dut):
    """
    Check all combinations with external stimuli
    """
    await init(dut)

    dut.stimuli.value = 1

    for inc, dec in product([0, 1], repeat=2):
        dut.sleep_controller_inc.value = inc
        dut.sleep_controller_dec.value = dec
        await Timer(1, units='ns')

        # Independent of sleep controller
        assert dut.stress_inc.value == 1
        assert dut.stress_dec.value == 0

    