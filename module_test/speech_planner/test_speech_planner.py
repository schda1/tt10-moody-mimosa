# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

MASK_EMOTION = 0b00_00_111_0_00000
MASK_ALL_BUT_EMOTION = 0b11_11_000_0_11111

MASK_ACTION = 0b00_11_000_0_00000
MASK_ALL_BUT_ACTION = 0b11_00_111_0_11111

MASK_DEV_STAGE = 0b11_00_000_0_00000
MASK_ALL_BUT_DEV_STAGE = 0b00_11_111_0_11111

ACTION_EAT = 1 << 1
ACTION_PLAY = 1 << 2
ACTION_CRY = 1 << 7
ACTION_SMILE = 1 << 3


async def init(dut):
    dut._log.info("Start")

    # Set the clock period to 100ns (10 MHz)
    clock = Clock(dut.clk, 100, units="ns")
    cocotb.start_soon(clock.start())

    dut.development_stage.value = 0
    dut.emotional_state.value = 0
    dut.action.value = 0

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)


@cocotb.test()
async def test_variant_bit(dut):
    """
    Check whether the variant bit toggles
    """
    await init(dut)

    assert dut.address.value == 0

    await ClockCycles(dut.clk, 1)
    assert dut.address.value == (1 << 5)

    await ClockCycles(dut.clk, 1)
    assert dut.address.value == 0


@cocotb.test()
async def test_emotion_bit(dut):
    """
    Check whether the address generation for the emotion bits is correct
    """

    await init(dut)

    for i in range(8):
        dut.emotional_state.value = 1 << i

        await ClockCycles(dut.clk, 1)
        address_val = int(dut.address.value)
        assert (address_val & MASK_EMOTION) >> 6 == i
        assert (address_val & MASK_ALL_BUT_EMOTION) == 0


@cocotb.test()
async def test_multiple_emotions(dut):
    """
    Check whether the address generation for the emotion bits is correct
    """

    await init(dut)

    dut.emotional_state.value = 1 << 1 | 1 << 3 | 1 << 5
    await ClockCycles(dut.clk, 1)
    assert (int(dut.address.value) & MASK_EMOTION) >> 6 == 1
    assert (int(dut.address.value) & MASK_ALL_BUT_EMOTION) == 0

    dut.emotional_state.value = 1 << 4 | 1 << 6 | 1 << 6
    await ClockCycles(dut.clk, 1)
    assert (int(dut.address.value) & MASK_EMOTION) >> 6 == 4
    assert (int(dut.address.value) & MASK_ALL_BUT_EMOTION) == 0


@cocotb.test()
async def test_special_actions(dut):
    """
    Check whether the address generation for the action bits is correct
    """

    await init(dut)

    dut.action.value = ACTION_EAT
    await ClockCycles(dut.clk, 1)
    assert (int(dut.address.value) & MASK_ACTION) >> 9 == 1
    assert (int(dut.address.value) & MASK_ALL_BUT_ACTION) == 0

    dut.action.value = ACTION_PLAY
    await ClockCycles(dut.clk, 1)
    assert (int(dut.address.value) & MASK_ACTION) >> 9 == 2
    assert (int(dut.address.value) & MASK_ALL_BUT_ACTION) == 0

    dut.action.value = ACTION_CRY
    await ClockCycles(dut.clk, 1)
    assert (int(dut.address.value) & MASK_ACTION) >> 9 == 3
    assert (int(dut.address.value) & MASK_ALL_BUT_ACTION) == 0

    # Irrelevant action
    dut.action.value = ACTION_SMILE
    await ClockCycles(dut.clk, 1)
    assert (int(dut.address.value) & MASK_ACTION) >> 9 == 0
    assert (int(dut.address.value) & MASK_ALL_BUT_ACTION) == 0

    # No action
    dut.action.value = 0
    await ClockCycles(dut.clk, 1)
    assert (int(dut.address.value) & MASK_ACTION) >> 9 == 0
    assert (int(dut.address.value) & MASK_ALL_BUT_ACTION) == 0


@cocotb.test()
async def test_development_stage(dut):
    """
    Check whether the address generation for the development stage
    """

    await init(dut)

    for i in range(4):
        dut.development_stage.value = i
        await ClockCycles(dut.clk, 1)
        assert (int(dut.address.value) & MASK_DEV_STAGE) >> 11 == i
        assert (int(dut.address.value) & MASK_ALL_BUT_DEV_STAGE) == 0
