# Background

In order to test and reconstruct the internal mimosa behaviour, I use an additional microcontroller to continously read the input and output pins of the ASIC (ui_in, uo_out etc). It also provides the clock signal (configurable via UART) and allows to reset the ASIC. Its main responsibility is to provide a consistent data set of all read pin values via UART. 

The receiver (laptop, PyQt application) feeds the data into the PyVerilator simulation and thus allows to get full insight into the internal, hidden information such as neurotransmitter levels or emotion and to log data. Moreover, the logged data allows to directly compare the ASIC behaviour with the intended behaviour, as simulated with the PyVerilator package. 

#  Firmware
Since I had a [nucleo with a STM32G474RE](https://www.st.com/en/evaluation-tools/nucleo-g474re.html) in a handy LQFP64 at hand, I decided to use this microcontroller, even though it is clearly overpowered for the task at hand. 

There are tons of options how to actually set up the application for the microcontroller.

1. Developing the entire application with the [STM32CubeIDE](https://www.st.com/en/development-tools/stm32cubeide.html) (Eclipse-based)
2. Developing a [Zephyr-application](https://github.com/zephyrproject-rtos/zephyr) (e.g. from VS Code), using the west build utilities.
3. [Platform-IO](https://platformio.org/): Developing an application for a nucleo board, with e.g. an Arduino-like "framework".
4. Setting up the application with STM32CubeMX (exporting with Makefile) but independently developing it inside VS Code and using the arm-none-aebi-gcc compiler. You can also debug it from VSCode, even you work inside WSL.

I ruled out option 1 and 3. I also decided not to set up a Zephyr application, mainly because I did not want to blow up the Dockercontainer with [installing the Zephyr SDK](https://github.com/zephyrproject-rtos/docker-image) and keep the procedure comprehensible for a larger audience not familiar with e.g. device trees. Instead, I decided to initially set up the application with STM32CubeMX and then develop the application independently from within VSCode. The driver files are now available from ST on [github](https://github.com/STMicroelectronics/STM32CubeG4) and I thus added them as a git submodule. In this way, the build process can be automated without violating license agreements. The arm gcc compiler is installed in the Dockerfile, so no additional manual steps are needed.

In order to build the firmware, just type `make` or e.g. `make -j16` to run several jobs in parallel. 

# CppUTest

In order to test the message parser module, I added some simple unit tests using [CppUTest](http://cpputest.github.io/). It is added as a submodule and installed in the `scripts/set_up_dependencies.sh` script. No manual steps are required. I follow the [suggested usage](https://github.com/jwgrenning/tddec-code) by J. W. Grenning, the maintainer of CppUTest and author of "Test-Driven Development for Embedded C". I added a Makefile to the tests folder in which the sources and additional folders (mocks, tests) are handled manually. Of course, for a more modern approach, you could also integrate it into CMake.

There are only few tests and only for the msg_parser module. This is a typical piece of code where you just know that there are bugs hidden or incorrectly handled edge cases. Although it relies on incoming uart data, it is pretty simple to test.

# Comments

- By default, the firmware is built in release configuration. If you want to build with debug symbols, you have to change the configuration in the makefile. However, building in debug configuration takes surprisingly long. 
- For advanced debugging, you probably should use the STM32CubeIDE or use professional tools such as a Segger J-LINK.
- There are various tools to flash the .hex file. You can e.g. use the [Stm32 ST-Link Utility]() or J-Flash, if you use a Segger J-Link. If you don't use a nucleo or have a custom PCB with a STM32 you can still use the ST-Link on a nucleo board in order to flash and debug your application with SWD.