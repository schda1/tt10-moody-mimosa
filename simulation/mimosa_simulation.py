import sys
from PyQt6.QtWidgets import QApplication

from mimosa_sim.model import MoodyMimosaSimulator
from mimosa_sim.view_qt import MainWindow
from mimosa_sim.controller_qt import SimulatorController

if __name__ == "__main__":
    app = QApplication(sys.argv)

    fram_resource_file = "phrases_german.txt"
    model = MoodyMimosaSimulator(fram_resource_file)
    view = MainWindow()
    controller = SimulatorController(model=model, view=view, delta_t=250)

    view.show()
    sys.exit(app.exec())
