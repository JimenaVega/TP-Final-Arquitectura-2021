import numpy as np
MEM_NAME = "register_bank.mem"

content = np.zeros(32, dtype=int)
content[0] = 8432 # 20f0
content[1] = 4351 # 10ff
def convert_to_binary_string(number):
    binary_string = bin(number)[2:]  # Remove the '0b' prefix
    padding = "0" * (8 - len(binary_string))  # Pad with zeros if necessary
    return padding + binary_string

# Generate the binary strings
binary_strings = [convert_to_binary_string(number) for number in content]

# Save the binary strings to a file
with open(MEM_NAME, "w") as file:
    file.write('\n'.join(binary_strings))
