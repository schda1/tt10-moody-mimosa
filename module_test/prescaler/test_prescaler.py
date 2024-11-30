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
    dut.clk_out_div_4.value = 0
    dut.clk_out_div_10.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

@cocotb.test()
async def test_prescaler_div_4(dut):
    """
    Check whether 4 prescaler actually divides input clock by 4. 
    """
    
    await init(dut)
    
    for i in range(16):

        for _ in range(2):
            assert dut.clk_out_div_4.value == 0
            await ClockCycles(dut.clk, 1)

        for _ in range(2):
            assert dut.clk_out_div_4.value == 1
            await ClockCycles(dut.clk, 1)
        
@cocotb.test()
async def test_prescaler_div_10(dut):
    """
    Check whether 10 prescaler actually divides input clock by 10. 
    """
    
    await init(dut)
    
    for i in range(16):

        for _ in range(5):
            assert dut.clk_out_div_10.value == 0
            await ClockCycles(dut.clk, 1)

        for _ in range(5):
            assert dut.clk_out_div_10.value == 1
            await ClockCycles(dut.clk, 1)
        
@cocotb.test()
async def test_prescaler_div_32(dut):
    """
    Check whether 32 prescaler (max) actually divides input clock by 32. 
    """
    
    await init(dut)
    
    for i in range(16):

        for _ in range(16):
            assert dut.clk_out_div_32.value == 0
            await ClockCycles(dut.clk, 1)

        for _ in range(16):
            assert dut.clk_out_div_32.value == 1
            await ClockCycles(dut.clk, 1)
        