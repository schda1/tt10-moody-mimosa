# Simulation

In order to simulate, a pyverilator wrapper is developed (`mimosa_lib/model.py`). This wrapper
uses verilator to create a C/C++ application out of the verilog sources (Verilator) and provides
a python interface to this compiled simulation. The user can provide input stimuli, advance the
clock and read the output state.

This model wrapper can be used to create an interactive python application (tkinter, PyQt), where
the user can adjust the input values and observe the internal states of the moody mimosa (energy
or stress level) and its output states. This should fine-tuning the details of the internal
emotional and physical state model in order to make an interesting device to play with.

# Set-up

Naively, I installed pyverilator and expected everything to work like a charm. However, the last
commit of the pyverilator repository is 5 years ago and well, long story short, it did not work.
However, thanks to a friendly fork of [bat52](https://github.com/bat52/pyverilator), there is a
pip-installable version available that works together with the Verilator version 4.038 installed
in the docker container. If you already have installed pyverilator, uninstall it and run

```
pip install pyverilator-mm
```

The wrapper for the `tt_um_moody_mimosa` design is part of the `mimosa_lib`. In order
to test your installation, run

```
python mimosa_lib/model.py
```

Side-remark: The final ASIC expectes a model-specific clock signal on input pin 0. In order
to be able to use the sim.clock.tick() pyverilator command, we want to couple the model clock
to the input clock. Therefore, we add an additional layer (`hdl/sim_moody_mimosa`) that adds
the clk clock (or a divided version) to input pin 0.

# PyQt

With PyQt, we add another level of complexity. I am running in the docker container as set up
in the `.devcontainer`, based on Ubuntu 22.04. However, my host machine is running docker
desktop on windows. So, by default, I cannot access the display from within the docker container.
A X-Server is required, such as e.g. [VcXsrv](https://vcxsrv.com/) or Xming, and the docker
container has to be configured
properly.

## Set up X-Server and install dependencies

- (On Windows): Download and run the X-Server, e.g. VcXsrv
- Add the docker run arguments `--env DISPLAY=host.docker.internal:0`, `-v /tmp/.X11-unix:/tmp/.X11-unix` (done automatically, see .devcontainer.json)
- Install dependencies used for X-Server, PyQt etc. (done automatically, see Dockerfile for details)
- Install python requirements with pip (done automatically, see .devcontainer.json postStartCommand)

Try to run `python test_app.py` and observe check a window opens or not.
