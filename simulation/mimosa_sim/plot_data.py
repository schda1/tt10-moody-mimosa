import os
import sys
import numpy as np
from numbers import Number
from model import ModelOutput
from dataclasses import dataclass

current_file_path = os.path.abspath(__file__)
current_dir_path = os.path.dirname(current_file_path)
sys.path.append(current_dir_path)
sys.path.append(os.path.join(current_dir_path, ".."))


class PlotData:
    """
    Flexible plotting data structure with support for type-based handling
    and nested attributes.
    """

    def __init__(self, start_len: int = 10):
        self.data = {}
        self.position = 0
        self.size = start_len

    def transform(self, key, value, cls_name=""):
        """
        Transform specific attributes, optionally using the class name.
        """
        # if "emotion" in key and isinstance(value, Number):
        #     return -1 if value == 0 else np.log2(value)
        return value

    def flatten_and_transform(self, obj, prefix="", cls_name=""):
        """
        Recursively flattens and applies transformations,
        storing floats and ints in separate arrays.
        """
        for key, value in obj.__dict__.items():
            full_key = f"{prefix}_{key}" if prefix else key
            if hasattr(value, "__dict__"):
                nested_cls_name = value.__class__.__name__
                self.flatten_and_transform(
                    value, prefix=full_key, cls_name=nested_cls_name
                )
            elif isinstance(value, float):
                if full_key not in self.data:
                    self.data[full_key] = np.zeros(self.size, dtype=np.float32)
                self.data[full_key][self.position] = self.transform(
                    full_key, value, cls_name
                )
            elif isinstance(value, (int, np.integer)):
                if full_key not in self.data:
                    self.data[full_key] = np.zeros(self.size, dtype=np.int16)
                self.data[full_key][self.position] = self.transform(
                    full_key, value, cls_name
                )

    def update(self, output) -> None:
        """
        Updates the plot data with a new ModelOutput instance.
        """
        # Get class name for context-aware handling
        cls_name = output.__class__.__name__

        # Flatten and transform the nested object
        self.flatten_and_transform(output, cls_name=cls_name)

        # Resize arrays if necessary
        if self.position >= self.size - 1:
            self.size *= 10
            for key in self.data:
                self.data[key] = np.resize(self.data[key], self.size)
            for key in self.data:
                self.data[key] = np.resize(self.data[key], self.size)

        self.position += 1
