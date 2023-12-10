from pyfiglet import figlet_format
import numpy as np
def generate_char_rom(crop=True, pad=True):
	with open("./sources/new/characters.rom", "w") as f:
		for char in range(32, 127):
			ascii_code = char
			# Get the character in the standard font
			char_art = figlet_format(chr(ascii_code), font="banner")
			print(char_art)
			# Extract the 8x8 pixel matrix
			char_matrix = [line[:8] for line in char_art.split("\n")]
			if pad:
				char_matrix = [line.ljust(8, "0") for line in char_matrix]
				char_matrix = [line.rjust(10, "0") for line in char_matrix]
				char_matrix.append("0" * 10)
			rawchar_bin = []
			for line in char_matrix:
				rawchar_bin.append(["1" if c == "#" else "0" for c in line])
			# print(rawchar_bin)
			npmat = np.array(rawchar_bin)
			# print(npmat)
			rotchar_matrix = np.rot90(npmat,3).tolist()
			# rotchar_matrix = rawchar_bin
			# rotchar_matrix = npmat.tolist()
			print(char_matrix)
			# Convert each line to binary
			char_bin = []
			for line in rotchar_matrix:
				line_bin = "".join(line)
				char_bin.append(line_bin)
				char_bin.append("\n")
			# Print the character code and binary matrix
			print(f"Character: {chr(ascii_code)} (Code: {ascii_code})")
			f.writelines(char_bin)
			# for line in char_bin:
			#     f.write(line)
			#     print(f"\t{line}")
		  	# print("")

if __name__ == "__main__":
	generate_char_rom()
