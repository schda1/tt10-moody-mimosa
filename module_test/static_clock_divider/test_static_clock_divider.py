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

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

@cocotb.test()
async def test_divide_by_2(dut):
    """
    Check whether output clock is half the input clock
    """
    await init(dut)

    for i in range(40):
        
        # Low for one cycle
        await ClockCycles(dut.clk, 1)
        await Timer(1, units='ns')
        assert dut.clk_out_by_2.value == 0
        
        # High for one cycle
        await ClockCycles(dut.clk, 1)
        await Timer(1, units='ns')
        assert dut.clk_out_by_2.value == 1
    
@cocotb.test()
async def test_divide_by_4(dut):
    """
    Check whether output clock 1/4 of the input clock
    """
    await init(dut)

    for i in range(40):
        
        # Low for two cycles
        for high in range(2):
            await ClockCycles(dut.clk, 1)
            await Timer(5, units='ns')
            assert dut.clk_out_by_4.value == 1
        
        # High for two cycles
        for low in range(2):
            await ClockCycles(dut.clk, 1)
            await Timer(5, units='ns')
            assert dut.clk_out_by_4.value == 0

@cocotb.test()
async def test_divide_by_8(dut):
    """
    Check whether output clock 1/8 of the input clock
    """
    await init(dut)
    await ClockCycles(dut.clk, 2)

    for i in range(40):
        
        # Low for two cycles
        for high in range(4):
            await ClockCycles(dut.clk, 1)
            await Timer(5, units='ns')
            assert dut.clk_out_by_8.value == 1
        
        # High for two cycles
        for low in range(4):
            await ClockCycles(dut.clk, 1)
            await Timer(5, units='ns')
            assert dut.clk_out_by_8.value == 0