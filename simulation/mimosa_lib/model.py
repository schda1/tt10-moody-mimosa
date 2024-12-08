import os
import sys
import shutil
import pyverilator
import numpy as np
import matplotlib.pyplot as plt
from dataclasses import dataclass

current_file_path = os.path.abspath(__file__)
current_dir_path = os.path.dirname(current_file_path)
sys.path.append(current_dir_path)

from bit_util import *

@dataclass
class ModelOutput:
    """
    Represents the output of the MoodyMimosa simulator 
    after one tick. Thee data that the ASCI or FPGA 
    module would provide through its output pins.
    """
    asleep: int = 0
    dying : int = 0
    state : int = 0
    energy: int = 0
    stress: int = 0
    pleasure: int = 0
    emotion: int = 0
    heartbeat: int = 0

@dataclass
class ModelInput:
    """
    Represents the input signals to the MoodyMimosa 
    simulator for a single tick. The data that the ASCI 
    or FPGA module would get through its input pins.
    """
    inc_stress: int = 0
    inc_pleasure: int = 0


RESET_SEQUENCE = [1, 0, 1]

class MoodyMimosaSimulator:
    """
    A simulator for the Moody Mimosa model. This class interfaces with the 
    Verilator-based simulation and provides methods to interact with it, 
    including ticking the simulator and reading outputs.
    """

    def __init__(self):
        self.sim : pyverilator.PyVerilator= self._init_sim()
        self.reset()

    def tick(self, input: ModelInput) -> ModelOutput:
        """
        Simulates one clock cycle with the provided input.

        Parameters:
        input (ModelInput): The input signals for the simulation.

        Returns:
        ModelOutput: The simulation outputs after one clock cycle.
        """
        # Prepare input signals
        ui_in = 0
        ui_in = def_bit(ui_in, 0, input.inc_stress)
        ui_in = def_bit(ui_in, 1, input.inc_pleasure)
        self.sim.io.ui_in = ui_in

        # Advance one clock cycle
        self.sim.clock.tick()

        # Prepare output data
        output = ModelOutput(asleep = read_bit(self.sim.io.uio_out, 0),
                             dying = read_bit(self.sim.io.uio_out, 1),
                             heartbeat = read_bit(self.sim.io.uio_out, 2),
                             emotion = int(self.sim.io.uo_out), 
                             energy = int(self.sim.io.dbg_energy), 
                             stress = int(self.sim.io.dbg_stress), 
                             pleasure = int(self.sim.io.dbg_pleasure))
        
        return output
    
    def reset(self) -> None:
        for rst_n in RESET_SEQUENCE:
            self.sim.io.rst_n = rst_n
            self.sim.clock.tick()

    def _init_sim(self) -> pyverilator.PyVerilator :
        # Remove verilator output folder
        if os.path.exists('obj_dir'):
            shutil.rmtree('obj_dir')

        # Create simulator
        hdl_sources = os.path.join(current_dir_path, '..', '..', 'src')
        sim_sources = os.path.join(current_dir_path, '..', 'hdl')

        sim = pyverilator.PyVerilator.build('sim_moody_mimosa.v', 
                                            verilog_path=[hdl_sources, sim_sources],
                                            verilog_defines=['PY_VERILATOR'], 
                                            quiet=True)
        return sim

def main():
    # Define the input signals
    input = ModelInput(inc_stress = 1, inc_pleasure = 0)

    # Initialize the simulator
    simulator = MoodyMimosaSimulator()

    # Run the simulation for one tick
    output = simulator.tick(input)

    # Print output
    print(output)

if __name__ == "__main__":
    main()
