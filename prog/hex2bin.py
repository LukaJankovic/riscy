#!/usr/bin/env python3

import sys

def hex_to_binary(hex_str):
    # Convert hex string to integer
    decimal_int = int(hex_str, 16)
    # Convert integer to binary string
    binary_str = bin(decimal_int)[2:].zfill(len(hex_str) * 4)
    return binary_str

if __name__ == "__main__":
    # Read input from stdin
    for line in sys.stdin:
        # Remove leading/trailing whitespaces and newline characters
        hex_input = line.strip()
        # Convert hex to binary
        binary_output = hex_to_binary(hex_input)
        print(binary_output)
