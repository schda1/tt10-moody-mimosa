# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

async def init(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut.ext_in.value = 0
    dut.counter.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

@cocotb.test()
async def test_counting(dut):
    """
    Check whether 4-bit counter actually counts up
    upon the rising edge of the input pin 0 and 
    whether it correcly overflows to 0 after 
    reaching the 16th iteration.
    """

    await init(dut)

    for i in range(1,32):
        # Set input to trigger counting up
        dut.ext_in.value = 1
        await ClockCycles(dut.clk, 2)
        assert dut.counter.value == i % 16

        # Set input back to zero
        dut.ext_in.value = 0
        await ClockCycles(dut.clk, 2)

@cocotb.test()
async def test_reset(dut):
    """
    Check whether reset turns counter value back to 0
    """

    await init(dut)

    # Pre-condition
    for i in range(7):
        dut.ext_in.value = 1
        await ClockCycles(dut.clk, 2)
        dut.ext_in.value = 0
        await ClockCycles(dut.clk, 2)

    # Check that counter has some finite value
    assert dut.counter.value != 0

    # Set reset to 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 1)

    # Check that counter is zero now
    assert dut.counter.value == 0