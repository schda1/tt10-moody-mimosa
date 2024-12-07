# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer, RisingEdge, FallingEdge, Edge

async def init(dut):
    dut._log.info("Start")

    # Set the clock period to 100ns (10 MHz)
    clock = Clock(dut.clk, 100, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut.x_2bit.value = 0
    dut.x_4bit.value = 0
    dut.clk_out_2bit.value = 0
    dut.clk_out_4bit.value = 0

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

@cocotb.test()
async def test_dyn_clock_div_reset(dut):
    """
    Check whether reset sets value to correct value
    """
    await init(dut)

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 2)
    assert dut.clk_out_4bit.value == 0

@cocotb.test()
async def test_dyn_clock_div_free_running(dut):
    """
    Check whether reset sets value to correct value
    """
    await init(dut)

    for x in range(6):
        dut.x_4bit.value = 8
        await ClockCycles(dut.clk, 2)

        dut.x_4bit.value = x
        await ClockCycles(dut.clk, 16)


@cocotb.test()
async def test_no_divider(dut):
    """
    Check whether output clock equals input clock for x = 0
    """
    await init(dut)

    dut.x_4bit.value = 0

    for i in range(10):
        await RisingEdge(dut.clk)
        await Timer(1, units='ns')
        assert dut.clk_out_4bit.value == 0

        await RisingEdge(dut.clk)
        await Timer(1, units='ns')
        assert dut.clk_out_4bit.value == 1
    
@cocotb.test()
async def test_divide_by_2(dut):
    """
    Check whether output clock is half for x = 1
    """
    await init(dut)

    dut.x_4bit.value = 1

    for i in range(10):

        for low in range(2):
            await RisingEdge(dut.clk)
            await Timer(1, units='ns')
            assert dut.clk_out_4bit.value == 0
        
        for high in range(2):
            await RisingEdge(dut.clk)
            await Timer(1, units='ns')
            assert dut.clk_out_4bit.value == 1

@cocotb.test()
async def test_divide_by_4(dut):
    """
    Check whether output clock is a quarter for x = 3
    """
    await init(dut)

    dut.x_4bit.value = 3
    await ClockCycles(dut.clk, 1)

    for i in range(10):

        # Four edges LOW
        for low in range(4):
            await RisingEdge(dut.clk)
            await Timer(1, units='ns')
            assert dut.clk_out_4bit.value == 0
        
        # Four edges HIGH
        for high in range(4):
            await RisingEdge(dut.clk)
            await Timer(1, units='ns')
            assert dut.clk_out_4bit.value == 1