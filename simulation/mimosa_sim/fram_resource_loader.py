import os
import sys


class FramResourceHandler:
    """
    The mimosa ASIC reads data from an external FRAM in order
    to talk to the player. We do not simulate the entire SPI
    FRAM communication. Instead, the resource file that is
    actually stored on the FRAM chip is used and the phrase
    is looked up in the file.
    """

    def __init__(self, filename: str):
        self.phrases = []
        self.filepath = self._determine_file_path(filename)
        self._load_resource_file()

    def read(self, address: int) -> str:
        """
        Get the phrase at the given address
        """
        index = address // 32

        if index < len(self.phrases):
            return self.phrases[index]

        return "Address out of bounds"

    def _load_resource_file(self) -> None:
        self.phrases = []

        with open(self.filepath, "r") as file:
            # Remove comment lines
            lines = [line for line in file.readlines() if line[0:2] != "//"]

            for line in lines:
                line = line.strip().ljust(32)[:32]
                self.phrases.append(line)

    def _determine_file_path(self, filename: str) -> str:
        current_file_path = os.path.abspath(__file__)
        current_dir_path = os.path.dirname(current_file_path)
        return os.path.join(current_dir_path, "..", "..", "resources", filename)


def print_content(handler: FramResourceHandler, address: int) -> None:
    phrase = handler.read(address)
    print(f'Phrase at {address:04x}: "{phrase}"')


def main() -> None:
    filename = "phrases_german.txt"
    handler = FramResourceHandler(filename)
    print_content(handler, 0x0020)
    print_content(handler, 0x1000)
    print_content(handler, 0x1200)


if __name__ == "__main__":
    main()
