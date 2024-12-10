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
        self.figure, self.ax = plt.subplots(nrows=2, ncols=2, figsize=(10, 4))
        self.canvas = FigureCanvas(self.figure)
        self.plotFrame.layout().addWidget(self.canvas)

    def update_plot(self, output: ModelOutput):
        """
        Updates the plot based on simulation output.
        """
        id = self.plot_data.position
        size = self.plot_data.size

        # Update plots
        self.figure.subplots_adjust(hspace=0.4, wspace=0.3)

        for ax in self.ax.flatten():
            ax.clear()

        self.ax[0, 0].plot(self.plot_data.energy[:id], label="Energy", color="blue", linewidth=1.5)
        self.ax[0, 0].set_ylabel("Energy", fontsize=9)
        self.ax[0, 0].tick_params(axis='both', labelsize=8)

        self.ax[0, 1].plot(self.plot_data.stress[:id], label="Stress", color="red", linewidth=1.5)
        self.ax[0, 1].set_ylabel("Stress", fontsize=9)
        self.ax[0, 1].tick_params(axis='both', labelsize=8)

        self.ax[1, 0].plot(self.plot_data.pleasure[:id], label="Pleasure", color="green", linewidth=1.5)
        self.ax[1, 0].set_ylabel("Pleasure", fontsize=9)
        self.ax[1, 0].tick_params(axis='both', labelsize=8)
        self.ax[1, 0].set_xlabel("Time steps", fontsize=9)

        self.ax[1, 1].plot(self.plot_data.nourishment[:id], label="Nourishment", color="orange", linewidth=1.5)
        self.ax[1, 1].set_ylabel("Nourishment", fontsize=9)
        self.ax[1, 1].tick_params(axis='both', labelsize=8)
        self.ax[1, 1].set_xlabel("Time steps", fontsize=9)

        for ax in self.ax.flatten():
            ax.set_xlim([0, size])
            ax.set_ylim([0, 128])
            ax.grid(True, linestyle='--', linewidth=0.5)
            ax.legend(fontsize=8)

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
