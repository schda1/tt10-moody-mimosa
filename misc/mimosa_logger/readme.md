# Background

In order to test and reconstruct the internal mimosa behaviour, I use an additional microcontroller to continously read the input and output pins of the ASIC (ui_in, uo_out etc). It also provides the clock signal (configurable via UART) and allows to reset the ASIC. Its main responsibility is to provide a consistent data set of all read pin values via UART. 

The receiver (laptop, PyQt application) feeds the data into the PyVerilator simulation and thus allows to get full insight into the internal, hidden information such as neurotransmitter levels or emotion and to log data. Moreover, the logged data allows to directly compare the ASIC behaviour with the intended behaviour, as simulated with the PyVerilator package. 

#  Firmware
Since I had a [nucleo with a STM32G474RE](https://www.st.com/en/evaluation-tools/nucleo-g474re.html) in a handy LQFP64 at hand, I decided to use this microcontroller, even though it is clearly overpowered for the task at hand. There are tons of options how to actually set up the application for the microcontroller.

1. Developing the entire application with the [STM32CubeIDE](https://www.st.com/en/development-tools/stm32cubeide.html) (Eclipse-based)
2. Developing a [Zephyr-application](https://github.com/zephyrproject-rtos/zephyr) (e.g. from VS Code), using the west build utilities.
3. [Platform-IO](https://platformio.org/): Developing an application for a nucleo board, with e.g. an Arduino-like "framework".
4. Setting up the application with STM32CubeMX (exporting with Makefile) but independently developing it inside VS Code and using the arm-none-aebi-gcc compiler. You can also debug it from VSCode. If you work from WSL2, you have to connect the relevant [USB ports](https://learn.microsoft.com/en-us/windows/wsl/connect-usb). 

I ruled out option 1 and 3. I also decided not to set up a Zephyr application, mainly because I did not want to blow up the Dockercontainer with [installing the Zephyr SDK](https://github.com/zephyrproject-rtos/docker-image) and keep the procedure comprehensible for a larger audience not familiar with e.g. device trees. Instead, I decided to initially set up the application with STM32CubeMX and then develop the application independently from within VSCode. The driver files are now available from ST on [github](https://github.com/STMicroelectronics/STM32CubeG4) and I thus added them as a git submodule. In this way, the build process can be automated without violating license agreements. The arm gcc compiler is installed in the Dockerfile, so no additional manual steps are needed.

In order to build the firmware, just type 
```
make -j16
```

# Comments

- By default, the firmware is built in release configuration. If you want to build with debug symbols, you have to change the configuration in the makefile. 
- For advanced debugging, you probably should use the STM32CubeIDE or use professional tools such as a Segger J-LINK.