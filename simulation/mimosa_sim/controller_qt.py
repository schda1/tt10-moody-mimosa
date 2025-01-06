from PyQt6.QtCore import QTimer
from mimosa_sim.model import ModelInput
from pprint import pprint


class SimulatorController:
    """
    Handles the communication between the MoodyMimosaSimulator (model)
    and the MainWindow (view).
    """

    def __init__(self, model, view, delta_t=1000):
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

        model_input = ModelInput()
        model_input.tickle = self.view.button_act_tickle.isChecked()
        model_input.play_with = self.view.button_act_play_with.isChecked()
        model_input.talk_to = self.view.button_act_talk_to.isChecked()
        model_input.calm_down = self.view.button_act_calm_down.isChecked()
        model_input.feed = self.view.button_act_feed.isChecked()
        model_input.env_cool = self.view.button_env_cool.isChecked()
        model_input.env_hot = self.view.button_env_hot.isChecked()
        model_input.env_quiet = self.view.button_env_quiet.isChecked()
        model_input.env_loud = self.view.button_env_loud.isChecked()
        model_input.env_dark = self.view.button_env_dark.isChecked()
        model_input.env_bright = self.view.button_env_bright.isChecked()

        # Perform a simulation tick
        output = self.model.tick(model_input)

        # Update the view with the new output
        self.view.plot_data.update(output)
        self.view.update_plot(output)
        self.view.update_indicators(output)
