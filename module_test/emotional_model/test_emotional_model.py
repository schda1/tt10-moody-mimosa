# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
import re
from cocotb.triggers import Timer

synonyms = {"LOW": 0, "OK": 1, "HIGH": 2, "HAPPY": 1, "COMFORTABLE": 2, "EXCITED": 4,
            "BORED": 8, "TIRED": 16, "ANGRY": 32, "NERVOUS": 64, "STRESSED": 128}

async def init(dut):
    dut._log.info("Start")
    dut.energy.value = 0
    dut.stress.value = 0
    dut.pleasure.value = 0
    dut.emotion.value = 0
    await Timer(1, units='ns')

def read_truth_table():

    rows = []
    
    # Read lines from truth table file
    with open("truth_table.txt", "r") as file:
        lines = file.readlines()[2:]
        
    # Extract relevant informtion from truth table file
    for line in lines:
        line = line.replace("|", "")
        line = re.sub(r'\s+', ' ', line).strip()

        for key, val in synonyms.items():
            line = line.replace(key, str(val))

        tokens = line.split(" ")

        rows.append({"Energy": int(tokens[0]), 
                     "Stress": int(tokens[1]),
                     "Pleasure": int(tokens[2]),
                     "Emotion": int(tokens[3])})
    return rows
  
@cocotb.test()
async def test_list(dut):
    """
    Test all relevant cases according to the given truth table
    """
    await init(dut)
   
    for row in read_truth_table():
        dut.energy.value = row['Energy']
        dut.stress.value = row['Stress']
        dut.pleasure.value = row['Pleasure']

        await Timer(1, units='ns')
        assert dut.emotion.value == row['Emotion']