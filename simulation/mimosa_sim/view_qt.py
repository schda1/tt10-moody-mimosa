import matplotlib.pyplot as plt
from matplotlib.backends.backend_qtagg import FigureCanvasQTAgg as FigureCanvas
from PyQt6.QtWidgets import QMainWindow, QVBoxLayout
from mimosa_sim.model import ModelOutput
from mimosa_sim.bit_util import read_bit
from ui.ui_main_app import Ui_MainWindow
from plot_data import PlotData


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
        self.figure, self.ax = plt.subplots(nrows=3, ncols=3, figsize=(11, 5))
        self.ax = self.ax.flatten()
        self.init_plot()

        self.canvas = FigureCanvas(self.figure)
        self.plotFrame.layout().addWidget(self.canvas)

    def init_plot(self):
        # Initialize plots
        self.ax[0].plot([], [], label="Dopamine", color="blue", linewidth=1.5)
        self.ax[0].plot([], [], label="Serotonin", color="red", linewidth=1.5)
        self.ax[1].plot([], [], label="Norepinephrine", color="blue", linewidth=1.5)
        self.ax[1].plot([], [], label="Cortisol", color="red", linewidth=1.5)
        self.ax[2].plot([], [], label="Gaba", color="blue", linewidth=1.5)
        self.ax[3].plot([], [], label="Nourishment", color="blue", linewidth=1.5)
        self.ax[4].plot([], [], label="Vital energy", color="blue", linewidth=1.5)
        self.ax[5].plot([], [], label="Hunger", color="blue", linewidth=1.5)
        self.ax[6].plot([], [], label="Illness", color="blue", linewidth=1.5)

        for ax in self.ax.flatten():
            ax.tick_params(axis="both", labelsize=6)
            ax.grid(True, linestyle="--", linewidth=0.5)
            ax.set_xlim([0, self.plot_data.size])
            ax.legend(fontsize=6)

        self.figure.tight_layout()
        self.figure.subplots_adjust(hspace=0.4, wspace=0.3)

    def update_plot(self, output: ModelOutput):
        """
        Updates the plot based on simulation output.
        """
        id = self.plot_data.position
        size = self.plot_data.size

        # Update the data for each nt dynamically
        self.ax[0].lines[0].set_data(range(id), self.plot_data.data["nt_dopamine"][:id])
        self.ax[0].lines[1].set_data(range(id), self.plot_data.data["nt_serotonin"][:id])
        self.ax[1].lines[0].set_data(range(id), self.plot_data.data["nt_norepinephrine"][:id])
        self.ax[1].lines[1].set_data(range(id), self.plot_data.data["nt_cortisol"][:id])
        self.ax[2].lines[0].set_data(range(id), self.plot_data.data["nt_gaba"][:id])
        self.ax[3].lines[0].set_data(range(id), self.plot_data.data["nourishment"][:id])
        self.ax[4].lines[0].set_data(range(id), self.plot_data.data["vital_energy"][:id])
        self.ax[6].lines[0].set_data(range(id), self.plot_data.data["illness"][:id])

        self.ax[5].lines[0].set_data(
            range(id),
            read_bit(self.plot_data.data["stimuli"][:id], 11),
        )

        for ax in self.ax.flatten():
            ax.set_xlim([0, size])
            ax.set_ylim([0, 128])

        self.canvas.draw()

    def update_indicators(self, output: ModelOutput):
        """
        Update the indicators for emotion, state and heartbeat
        """
        # Update emotion
        self.led_emo_happy.setChecked(read_bit(output.emotional_state, 0))
        self.led_emo_excited.setChecked(read_bit(output.emotional_state, 1))
        self.led_emo_stressed.setChecked(read_bit(output.emotional_state, 2))
        self.led_emo_nervous.setChecked(read_bit(output.emotional_state, 3))
        self.led_emo_bored.setChecked(read_bit(output.emotional_state, 4))
        self.led_emo_angry.setChecked(read_bit(output.emotional_state, 5))
        self.led_emo_calm.setChecked(read_bit(output.emotional_state, 6))
        self.led_emo_apathetic.setChecked(read_bit(output.emotional_state, 7))

        # Update action
        self.led_act_sleep.setChecked(read_bit(output.action, 0))
        self.led_act_eat.setChecked(read_bit(output.action, 1))
        self.led_act_play.setChecked(read_bit(output.action, 2))
        self.led_act_smile.setChecked(read_bit(output.action, 3))
        self.led_act_babble.setChecked(read_bit(output.action, 4))
        self.led_act_kick_legs.setChecked(read_bit(output.action, 5))
        self.led_act_idle.setChecked(read_bit(output.action, 6))
        self.led_act_cry.setChecked(read_bit(output.action, 7))
