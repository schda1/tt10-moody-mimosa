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
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)


@cocotb.test()
async def test_prescaler(dut):
    """
    Check whether 4 prescaler actually divides input clock by 4. 
    """
    
    await init(dut)
    
    for i in range(16):
        # Two cycles low
        assert dut.uo_out.value[7] == 0
        await ClockCycles(dut.clk, 1)
        assert dut.uo_out.value[7] == 0
        await ClockCycles(dut.clk, 1)
        # Two cycles high
        assert dut.uo_out.value[7] == 1
        await ClockCycles(dut.clk, 1)
        assert dut.uo_out.value[7] == 1
        await ClockCycles(dut.clk, 1)
        

def check_sum(value, value_exp):
    assert (value & 0x1E) >> 1 == (value_exp % 16)


@cocotb.test()
async def test_counter(dut):
    """
    Check whether 4-bit counter actually counts up
    upon the rising edge of the input pin 0 and 
    whether it correcly overflows to 0 after 
    reaching the 16th iteration.
    """

    await init(dut)

    for i in range(32):
        # Set input to trigger counting up
        dut.ui_in.value = 1
        await ClockCycles(dut.clk, 2)
        check_sum(dut.uo_out.value, i+1)

        # Set input back to zero
        dut.ui_in.value = 0
        await ClockCycles(dut.clk, 2)
