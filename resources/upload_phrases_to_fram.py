import serial
import argparse
import time

BAUD_RATE = 115200
MAX_REPS = 5


def write_cmd(serial: serial.Serial, cmd: str, timeout: float = 0.02) -> str:
    """
    Write command to serial port and return response
    """
    serial.write(cmd.encode())
    time.sleep(timeout)

    response = b""
    while serial.in_waiting > 0:
        response += serial.read(serial.in_waiting)

    try:
        return response.decode("utf-8")
    except UnicodeDecodeError:
        return response.decode("utf-8", errors="replace")


def prepare_for_upload(serial: serial.Serial) -> None:
    """
    Initialize MCU for FRAM upload
    """
    write_cmd(serial, ":RST_MIMOSA;1\n")
    write_cmd(serial, ":FRAM_INIT;1\n", timeout=0.5)
    write_cmd(serial, ":FRAM_ERASE\n", timeout=3)


def write_file_to_fram(serial: serial.Serial, filename: str) -> None:
    """
    Write data to FRAM. Since there might be issues, the data sent is
    verified directly afterwards and if it doesn't match, the upload
    procedure is repeated.
    """

    with open(filename, "r") as file:
        lines = [line for line in file.readlines() if line[0:2] != "//"]

        for i, line in enumerate(lines):
            line = line.strip().ljust(32)
            line = line[:32]
            address = i * 32

            for i in range(10):
                cmd = f":FRAM_WRITE;{address};{line}\n"
                print(f"{i}, [{cmd[:-1]}]")
                write_cmd(serial, cmd, 0.02)

                cmd = f":FRAM_READ;{address}\n"
                response = write_cmd(serial, cmd, 0.02)
                response = response.replace("\x0e", "")

                if "Read FRAM:" in response:
                    if line.strip() == response[11:-1].strip():
                        break

                if i > MAX_REPS:
                    raise Exception(f"Failed to write line: {line} to address {address}")


def finish_upload(serial: serial.Serial) -> None:
    """
    Finish upload moad and de-initialize FRAM and SPI
    """
    write_cmd(serial, ":INIT_FRAM;0\n")
    write_cmd(serial, ":RST_MIMOSA;0\n")


def main(args):
    serial_port = None
    try:
        print(f"Connecting to {args.com_port}")
        time.sleep(1)

        serial_port = serial.Serial(port=args.com_port, baudrate=BAUD_RATE)
        prepare_for_upload(serial_port)
        write_file_to_fram(serial_port, args.filename)
        finish_upload(serial_port)
        serial_port.close()

    except Exception as e:
        print(f"Error: {e}")
    finally:
        if serial_port and serial_port.is_open:
            serial_port.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Upload phrases to FRAM")
    parser.add_argument("com_port", type=str, help="COM port to connect to")
    parser.add_argument("filename", type=str, help="Filename to read phrases from")
    args = parser.parse_args()

    main(args)
