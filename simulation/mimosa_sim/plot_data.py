import numpy as np
from mimosa_sim.model import ModelOutput

class PlotData:
    """
    Carries the data necessary for plotting
    """
    def __init__(self, start_len:int = 10):
        self.energy: np.ndarray = np.zeros(start_len)
        self.stress: np.ndarray = np.zeros(start_len)
        self.pleasure: np.ndarray = np.zeros(start_len)
        self.emotion: np.ndarray = np.zeros(start_len)
        self.position: int = 0
        self.size: int = start_len

    def update(self, output: ModelOutput) -> None:
         # Reshape plot data if full
        if self.position >= self.energy.shape[0]:
            self.size = self.energy.shape[0] * 2
            self.energy = np.resize(self.energy, self.size)
            self.stress = np.resize(self.stress, self.size)
            self.pleasure = np.resize(self.pleasure, self.size)
            self.emotion = np.resize(self.emotion, self.size)

        # Add output to plot data
        id = self.position
        
        self.energy[id] = output.energy
        self.stress[id] = output.stress
        self.pleasure[id] = output.pleasure
        self.emotion[id] = -1 if output.emotion == 0 else np.log2(output.emotion)
        self.position += 1
