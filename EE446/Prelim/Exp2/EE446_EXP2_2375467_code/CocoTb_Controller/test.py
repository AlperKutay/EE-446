original_variable = 0b00010011000100001010000011100011

# Convert the variable to a binary string and slice the first 4 characters
bits_10_11_12 = (original_variable >>28) & 0b1111  # Shift 9 bits to the right to align bit 12 to the 0th position, then mask to keep only 3 bits

# Print the extracted bits
print("Bits 10-12:", bin(bits_10_11_12))