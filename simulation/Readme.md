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