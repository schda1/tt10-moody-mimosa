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
    dut.stimulus.value = 0
    dut.state.value = 0

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 10)

@cocotb.test()
async def test_reanimator_dying(dut):
    """
    Has no effect if dead
    """
    
    await init(dut)

    dut.state.value = 1
    await ClockCycles(dut.clk, 2)

    # Just started dying
    dut.state.value = 2
    await ClockCycles(dut.clk, 1)

    # No reanimation
    for _ in range(10):
        await ClockCycles(dut.clk, 1)
        assert dut.reanimated.value == 0
    
    # Start with reanimation
    dut.stimulus.value = 1

    for _ in range(5):
        await ClockCycles(dut.clk, 1)
        assert dut.reanimated.value == 0

    for _ in range(5):
        await ClockCycles(dut.clk, 1)
        assert dut.reanimated.value == 1

@cocotb.test()
async def test_reanimator_awake(dut):
    """
    Has no effect if awake 
    """
    
    await init(dut)

    dut.state.value = 0

    for i in range(10):
        dut.stimulus.value = 0
        await ClockCycles(dut.clk, 1)
        assert dut.reanimated.value == 0

        dut.stimulus.value = 1
        await ClockCycles(dut.clk, 1)
        assert dut.reanimated.value == 0

@cocotb.test()
async def test_reanimator_asleep(dut):
    """
    Has no effect if asleep
    """
    
    await init(dut)

    dut.state.value = 1

    for i in range(10):
        dut.stimulus.value = 0
        await ClockCycles(dut.clk, 1)
        assert dut.reanimated.value == 0

        dut.stimulus.value = 1
        await ClockCycles(dut.clk, 1)
        assert dut.reanimated.value == 0

@cocotb.test()
async def test_reanimator_dead(dut):
    """
    Has no effect if dead
    """
    
    await init(dut)

    dut.state.value = 3

    for i in range(10):
        dut.stimulus.value = 0
        await ClockCycles(dut.clk, 1)
        assert dut.reanimated.value == 0

        dut.stimulus.value = 1
        await ClockCycles(dut.clk, 1)
        assert dut.reanimated.value == 0