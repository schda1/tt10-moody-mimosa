# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
import re
from cocotb.triggers import Timer

async def init(dut):
    dut._log.info("Start")
    dut.emotion.value = 0
    dut.asleep.value = 0
    dut.heartbeat.value = 0
    await Timer(1, units='ns')

def read_truth_table():

    rows = []
    
    # Read lines from truth table file
    with open("truth_table_heartbeat.txt", "r") as file:
        lines = file.readlines()[2:]
        
    # Extract relevant informtion from truth table file
    for line in lines:
        line = line.replace("|", "")
        line = re.sub(r'\s+', ' ', line).strip()

        tokens = line.split(" ")

        rows.append({"Emotion": int(tokens[1]), 
                     "Sleep": int(tokens[2]),
                     "Heartbeat": int(tokens[3])})
    return rows
  

@cocotb.test()
async def test_truth_table(dut):
    """
    Check all combinations from heartbeat truth table
    """
    await init(dut)

    for row in read_truth_table():
        dut.emotion.value = row['Emotion']
        dut.asleep.value = row['Sleep']
        await Timer(1, units='ns')
        assert dut.heartbeat.value == row['Heartbeat']