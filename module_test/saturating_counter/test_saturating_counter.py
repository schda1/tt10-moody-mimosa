# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

async def init(dut):
    dut._log.info("Start")

    # Set the clock period to 100ns (10 MHz)
    clock = Clock(dut.clk, 100, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut.inc.value = 0
    dut.dec.value = 0
    dut.setval.value = 0

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 10)


@cocotb.test()
async def test_sat_counter_init(dut):
    """
    Check initial values 
    """
    
    await init(dut)

    # Check that initial value is 1 or value specified
    assert dut.value_2bit.value == 2
    assert dut.value_8bit.value == 2
    assert dut.value_16bit.value == 2

@cocotb.test()
async def test_sat_counter_reset(dut):
    """
    Check whether reset sets value to correct value
    """
    
    await init(dut)

    dut.inc.value = 1
    await ClockCycles(dut.clk, 2)

    # Check that value is not 2^N/2
    assert dut.value_2bit.value != 2
    assert dut.value_8bit.value != 2
    assert dut.value_16bit.value != 2

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 2)

    # Check that value is 2^N/2
    assert dut.value_2bit.value == 2
    assert dut.value_8bit.value == 2
    assert dut.value_16bit.value == 2

@cocotb.test()
async def test_sat_counter_2bit(dut):
    """
    Check behaviour of 2bit counter (moving first up
    and then down, checking incremental steps and 
    saturation)
    """

    decs = [0, 0, 0, 0, 1, 1, 1, 1, 1, 1]
    incs = [1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
    exps = [2, 3, 3, 3, 3, 2, 1, 0, 0, 0]
    
    await init(dut)

    for (dec, inc, exp) in zip(decs, incs, exps):
        dut.dec.value = dec
        dut.inc.value = inc
        
        await ClockCycles(dut.clk, 1)
        assert dut.value_2bit.value == exp

@cocotb.test()
async def ttest_sat_counter_setval(dut):
    """
    Check whether predefined value can be set
    """
    
    await init(dut)

    dut.setval.value = 1
    await ClockCycles(dut.clk, 2)

    assert dut.value_2bit.value == 1
    assert dut.value_8bit.value == 200
    assert dut.value_16bit.value == 1000