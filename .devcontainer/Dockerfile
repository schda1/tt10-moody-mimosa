ARG VARIANT=ubuntu-22.04
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

ENV DEBIAN_FRONTEND=noninteractive
ENV PDK_ROOT=/home/vscode/ttsetup/pdk
ENV PDK=sky130A

RUN apt update
RUN apt install -y iverilog gtkwave python3 python3-pip python3-venv python3-tk python-is-python3 libcairo2 verilator libpng-dev libqhull-dev

# Install dependencies for GUI (X11, Qt5, etc.)
RUN apt-get update && \
    apt-get install -y \
    qt5-qmake \
    qtbase5-dev \
    qtchooser \
    qtbase5-dev-tools \
    libqt5gui5 \
    libqt5core5a \
    libqt5widgets5 \
    libglib2.0-0 \
    libxcb1 \
    libgl1-mesa-glx \
    x11-apps \
    libx11-dev \
    libxrender-dev \
    autoconf \
    cmake \
    && apt-get clean

# Install arm gcc compiler for stm32 logger application 
RUN apt-get install -y gcc-arm-none-eabi

# Allow access to X server (from within the container)
RUN apt-get install -y x11-xserver-utils

# Set environment variable for DISPLAY to point to Windows host (Docker for Windows uses host.docker.internal)
ENV DISPLAY=host.docker.internal:0

# Clone tt-support-tools
RUN mkdir -p /ttsetup
RUN git clone -b tt10 https://github.com/TinyTapeout/tt-support-tools /ttsetup/tt-support-tools
COPY test/requirements.txt /ttsetup/test_requirements.txt
COPY .devcontainer/copy_tt_support_tools.sh /ttsetup

RUN pip3 install -r /ttsetup/test_requirements.txt -r /ttsetup/tt-support-tools/requirements.txt

# Install verible (for formatting)
RUN umask 022 && \
    curl -L https://github.com/chipsalliance/verible/releases/download/v0.0-3795-gf4d72375/verible-v0.0-3795-gf4d72375-linux-static-x86_64.tar.gz | \
    tar zxf - -C /usr/local --strip-components=1 && \
    chmod 755 /usr/local/bin

# Install openlane
RUN pip3 install openlane==2.1.5
