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
class NeurotransmitterLevels:
    """
    Collects the neurotransmitter levels
    associated with the mimosa
    """

    cortisol: int = 0
    dopamine: int = 0
    gaba: int = 0
    norepinephrine: int = 0
    serotonin: int = 0


@dataclass
class ModelOutput:
    """
    Represents the output of the MoodyMimosa simulator
    after one tick. Thee data that the ASCI or FPGA
    module would provide through its output pins.
    """

    nt: NeurotransmitterLevels
    nourishment: int = 0
    vital_energy: int = 0
    emotional_state: int = 0
    heartbeat: int = 0
    action: int = 0
    stimuli: int = 0
    illness: int = 0
    is_ill: int = 0


@dataclass
class ModelInput:
    """
    Represents the input signals to the MoodyMimosa
    simulator for a single tick. The data that the ASCI
    or FPGA module would get through its input pins.
    """

    tickle: int = 0
    play_with: int = 0
    talk_to: int = 0
    calm_down: int = 0
    feed: int = 0
    env_cool: int = 0
    env_hot: int = 0
    env_quiet: int = 0
    env_loud: int = 0
    env_dark: int = 0
    env_bright: int = 0


RESET_SEQUENCE = [1, 0, 1]


class MoodyMimosaSimulator:
    """
    A simulator for the Moody Mimosa model. This class interfaces with the
    Verilator-based simulation and provides methods to interact with it,
    including ticking the simulator and reading outputs.
    """

    def __init__(self):
        self.sim: pyverilator.PyVerilator = self._init_sim()
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
        ui_in = def_bit(ui_in, 1, input.tickle)
        ui_in = def_bit(ui_in, 2, input.play_with)
        ui_in = def_bit(ui_in, 3, input.talk_to)
        ui_in = def_bit(ui_in, 4, input.calm_down)
        ui_in = def_bit(ui_in, 5, input.feed)
        ui_in = def_bit(ui_in, 6, input.env_cool)
        ui_in = def_bit(ui_in, 7, input.env_hot)

        self.sim.io.ui_in = ui_in

        # Advance one clock cycle
        self.sim.clock.tick()

        # Prepare output data
        neurotransmitter = NeurotransmitterLevels(
            cortisol=int(self.sim.io.dbg_cortisol),
            dopamine=int(self.sim.io.dbg_dopamine),
            gaba=int(self.sim.io.dbg_gaba),
            norepinephrine=int(self.sim.io.dbg_norepinephrine) * 2,
            serotonin=int(self.sim.io.dbg_serotonin),
        )

        output = ModelOutput(
            action=int(self.sim.io.dbg_action),
            emotional_state=int(self.sim.io.dbg_emotional_state),
            heartbeat=int(self.sim.io.dbg_heartbeat),
            stimuli=int(self.sim.io.dbg_stimuli),
            nourishment=int(self.sim.io.dbg_nourishment) // 2,
            vital_energy=int(self.sim.io.dbg_vital_energy) // 2,
            illness=int(self.sim.io.dbg_illness) // 4,
            is_ill=read_bit(int(self.sim.io.dbg_stimuli), 14),
            nt=neurotransmitter,
        )

        return output

    def reset(self) -> None:
        for rst_n in RESET_SEQUENCE:
            self.sim.io.rst_n = rst_n
            self.sim.clock.tick()

    def _init_sim(self, force: bool = True) -> pyverilator.PyVerilator:
        # Remove verilator output folder
        if os.path.exists("obj_dir"):
            shutil.rmtree("obj_dir")

        # Create simulator
        source_folders = [
            "action",
            "emotion",
            "heartbeat",
            "neurotransmitter",
            "nourishment",
            "sleep",
            "utility",
            "illness",
        ]

        base_path = os.path.join(current_dir_path, "..", "..", "src")
        sources = []
        sources.append(base_path)
        sources.append(os.path.join(current_dir_path, "..", "hdl"))

        for folder in source_folders:
            sources.append(os.path.join(base_path, folder))

        sim = pyverilator.PyVerilator.build(
            "sim_moody_mimosa.v",
            verilog_path=sources,
            verilog_defines=["PY_SIM"],
            quiet=True,
        )
        return sim


def main():
    # Define the input signals
    input = ModelInput()

    # Initialize the simulator
    simulator = MoodyMimosaSimulator()

    # Run the simulation for one tick
    output = simulator.tick(input)

    # Print output
    print(output)


if __name__ == "__main__":
    main()
