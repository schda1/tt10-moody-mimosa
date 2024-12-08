from PyQt6.QtCore import QTimer
from mimosa_sim.model import ModelInput

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
        self.view.plot_data.update(output)
        self.view.update_plot(output)
        self.view.update_indicators(output)