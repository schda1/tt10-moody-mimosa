# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer

async def init(dut):
    dut._log.info("Start")

    # Set the clock period to 100ns (10 MHz)
    clock = Clock(dut.clk, 100, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut.energy_indicator.value = 2
    dut.stress_indicator.value = 0

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

@cocotb.test()
async def test_sleep_controller_reset(dut):

    await init(dut)

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 1)

    assert dut.asleep.value == 0
    assert dut.fell_asleep.value == 0
    assert dut.en_inc.value == 0
    assert dut.en_dec.value == 0

@cocotb.test()
async def test_sleep_controller_stay_awake(dut):
    """
    Staying awake, not yet tired.
    """

    await init(dut)

    dut.energy_indicator.value = 2
    dut.stress_indicator.value = 0

    await ClockCycles(dut.clk, 1)
    await Timer(1, units='ns')

    assert dut.asleep.value == 0    
    assert dut.fell_asleep.value == 0
    assert dut.en_inc.value == 0
    assert dut.en_dec.value == 1

@cocotb.test()
async def test_sleep_controller_fall_asleep(dut):
    """
    Fall asleep, too tired.
    """

    await init(dut)

    dut.energy_indicator.value = 0
    dut.stress_indicator.value = 0

    await ClockCycles(dut.clk, 1)
    await Timer(1, units='ns')
    assert dut.fell_asleep.value == 1

    await ClockCycles(dut.clk, 1)
    await Timer(1, units='ns')

    assert dut.asleep.value == 1    
    assert dut.fell_asleep.value == 0
    assert dut.en_inc.value == 1
    assert dut.en_dec.value == 0

@cocotb.test()
async def test_sleep_controller_stay_awake_stressed(dut):
    """
    Stay awake, tired but too stressed
    """

    await init(dut)

    dut.energy_indicator.value = 0
    dut.stress_indicator.value = 3

    await ClockCycles(dut.clk, 1)
    await Timer(1, units='ns')

    assert dut.asleep.value == 0    
    assert dut.fell_asleep.value == 0
    assert dut.en_inc.value == 0
    assert dut.en_dec.value == 1

@cocotb.test()
async def test_sleep_controller_wake_up_recovered(dut):
    """
    Wake up, felling great
    """

    await init(dut)

    dut.energy_indicator.value = 0
    dut.stress_indicator.value = 0

    # Sleep in
    await ClockCycles(dut.clk, 2)
    await Timer(1, units='ns')
    assert dut.asleep.value == 1   

    # Not yet woken up
    dut.energy_indicator.value = 2
    await ClockCycles(dut.clk, 2)
    await Timer(1, units='ns')
    assert dut.asleep.value == 1   

    # Energy high, time to wake up
    dut.energy_indicator.value = 3
    await ClockCycles(dut.clk, 2)
    await Timer(1, units='ns')
    assert dut.asleep.value == 0   

@cocotb.test()
async def test_sleep_controller_wake_up_stressed(dut):
    """
    Wake up, stress too high
    """

    await init(dut)

    dut.energy_indicator.value = 0
    dut.stress_indicator.value = 0

    # Sleep in
    await ClockCycles(dut.clk, 2)
    await Timer(1, units='ns')
    assert dut.asleep.value == 1   

    # Not yet woken up
    dut.energy_indicator.value = 2
    dut.stress_indicator.value = 2
    await ClockCycles(dut.clk, 2)
    await Timer(1, units='ns')
    assert dut.asleep.value == 1   

    # Wake up, too much stress
    dut.energy_indicator.value = 2
    dut.stress_indicator.value = 3
    await ClockCycles(dut.clk, 2)
    await Timer(1, units='ns')
    assert dut.asleep.value == 0   