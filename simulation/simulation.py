import sys
import numpy as np
import matplotlib.pyplot as plt
from dataclasses import dataclass, field
from matplotlib.backends.backend_qtagg import FigureCanvasQTAgg as FigureCanvas
from PyQt6.QtCore import QTimer
from PyQt6.QtWidgets import QApplication, QMainWindow, QVBoxLayout
from mimosa_lib.model import ModelInput, ModelOutput, MoodyMimosaSimulator
from mimosa_lib.bit_util import read_bit
from ui_main_app import Ui_MainWindow 

@dataclass
class PlotData:
    """
    Carries the data necessary for plotting
    """
    energy: np.ndarray = field(default_factory=lambda: np.zeros(10))
    stress: np.ndarray = field(default_factory=lambda: np.zeros(10))
    pleasure: np.ndarray = field(default_factory=lambda: np.zeros(10))
    emotion: np.ndarray = field(default_factory=lambda: np.zeros(10)) 
    position: int = 0

class SimulatorController:
    """
    Handles the communication between the MoodyMimosaSimulator (model) 
    and the MainWindow (view).
    """
    def __init__(self, model, view, delta_t=500):
        self.model = model
        self.view = view
        self.delta_t = delta_t  

        # Timer for periodic updates
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_simulation)

        self._connect_signals()
        self.timer.start(self.delta_t)

    def _connect_signals(self):
        self.view.pushButton.clicked.connect(self.run_simulation_once)

    def run_simulation_once(self):
        self.update_simulation()

    def update_simulation(self):
        """
        Update the simulation by first reading the inputs
        of the users and updating the mimosa simulation with
        the corresponding inputs
        """

        model_input = ModelInput(
            inc_stress=0,
            inc_pleasure=0
        )

        # Perform a simulation tick
        output = self.model.tick(model_input)

        # Update the view with the new output
        self.view.update_plot(output)
        self.view.update_indicators(output)

class MainWindow(QMainWindow, Ui_MainWindow):
    def __init__(self):
        super().__init__()
        self.setupUi(self)
        self.plot_data = PlotData()

        # Ensure plotFrame has a layout
        if not self.plotFrame.layout():
            layout = QVBoxLayout(self.plotFrame)
            self.plotFrame.setLayout(layout)

        # Create a matplotlib figure and canvas
        self.figure, self.ax = plt.subplots(nrows=2, ncols=2, figsize=(10, 4))
        self.canvas = FigureCanvas(self.figure)
        self.plotFrame.layout().addWidget(self.canvas)

    def update_plot(self, output: ModelOutput):
        """
        Updates the plot based on simulation output.
        """

        # Reshape plot data if full
        if self.plot_data.position >= self.plot_data.energy.shape[0]:
            new_size = self.plot_data.energy.shape[0] * 2
            self.plot_data.energy = np.resize(self.plot_data.energy, new_size)
            self.plot_data.stress = np.resize(self.plot_data.stress, new_size)
            self.plot_data.pleasure = np.resize(self.plot_data.pleasure, new_size)
            self.plot_data.emotion = np.resize(self.plot_data.emotion, new_size)

        # Add output to plot data
        id = self.plot_data.position
        size = self.plot_data.energy.shape[0]
        self.plot_data.energy[id] = output.energy
        self.plot_data.stress[id] = output.stress
        self.plot_data.pleasure[id] = output.pleasure
        self.plot_data.emotion[id] = -1 if output.emotion == 0 else np.log2(output.emotion)
        self.plot_data.position += 1

        # Update plots
        self.figure.subplots_adjust(hspace=0.4, wspace=0.3)

        for ax in self.ax.flatten():
            ax.clear()

        self.ax[0, 0].plot(self.plot_data.energy[:id+1], label="Energy", color="blue", linewidth=1.5)
        self.ax[0, 0].set_ylabel("Energy", fontsize=9)
        self.ax[0, 0].tick_params(axis='both', labelsize=8)

        self.ax[0, 1].plot(self.plot_data.stress[:id+1], label="Stress", color="red", linewidth=1.5)
        self.ax[0, 1].set_ylabel("Stress", fontsize=9)
        self.ax[0, 1].tick_params(axis='both', labelsize=8)

        self.ax[1, 0].plot(self.plot_data.pleasure[:id+1], label="Pleasure", color="green", linewidth=1.5)
        self.ax[1, 0].set_ylabel("Pleasure", fontsize=9)
        self.ax[1, 0].tick_params(axis='both', labelsize=8)
        self.ax[1, 0].set_xlabel("Time steps", fontsize=9)

        self.ax[1, 1].plot(self.plot_data.emotion[:id+1], label="Emotion", color="orange", linewidth=1.5)
        self.ax[1, 1].set_ylabel("Emotion", fontsize=9)
        self.ax[1, 1].tick_params(axis='both', labelsize=8)
        self.ax[1, 1].set_xlabel("Time steps", fontsize=9)

        for ax in self.ax.flatten():
            ax.set_xlim([0, size])
            ax.set_ylim([0, 128])
            ax.grid(True, linestyle='--', linewidth=0.5)
            ax.legend(fontsize=8)

        self.ax[1, 1].set_ylim([0, 10])

        self.figure.tight_layout()
        self.canvas.draw()

    def update_indicators(self, output: ModelOutput):
        """
        Update the indicators for emotion, state and heartbeat
        """
        # Update emotion
        self.led_em_happy.setChecked(read_bit(output.emotion,0))
        self.led_em_comfortable.setChecked(read_bit(output.emotion,1))
        self.led_em_excited.setChecked(read_bit(output.emotion,2))
        self.led_em_bored.setChecked(read_bit(output.emotion,3))
        self.led_em_tired.setChecked(read_bit(output.emotion,4))
        self.led_em_angry.setChecked(read_bit(output.emotion,5))
        self.led_em_nervous.setChecked(read_bit(output.emotion,6))
        self.led_em_stressed.setChecked(read_bit(output.emotion,7))
        
        # Update hearbeat and state
        self.led_heartbeat.setChecked(output.heartbeat)
        self.led_st_awake.setChecked(output.emotion > 0)
        self.led_st_asleep.setChecked(output.asleep)
        self.led_st_dying.setChecked(output.dying)

        is_dead = output.emotion == 0 and output.asleep == 0 and output.dying == 0
        self.led_st_dead.setChecked(is_dead)

if __name__ == "__main__":
    app = QApplication(sys.argv)

    model = MoodyMimosaSimulator()
    view = MainWindow()
    controller = SimulatorController(model=model, view=view, delta_t=200)

    view.show()
    sys.exit(app.exec())