# Modular-Multiplier
A System Verilog Design of the Shift-sub Modular Multiplier Algorithm 

This repository introduces a Shift-Sub Modular Multiplication (SSMM) algorithm SSMMul(a, b, m) to calculate ***z = ab mod m*** that uses only addition, subtraction, and shift calculations for a, b < m
# The Shift-Sub Modular Multiplier algorithm is shown in the following figure
![image](https://github.com/MahmouodMagdi/Modular-Multiplier/assets/72949261/e06cca59-3a62-4f8d-9c9f-f0a98176ef5d)


- **Note**: the computational complexity of the Shift-Sub Modualr Multiplier is the same as that of Motgomery Modular Multiplier
- The advantage of the Shift-Sub Modular Multiplier is that it does not require any domain transformation which was done in the montgomery algorithms
- The correctness of the SSMM algorithm is based on the following fact: Because we are calculating z = ab mod m, we can add/subtract multiples of m to/from z.
- The Implemented algorithm computes the modular multiplication of a*b mod(m) up to 256 bits
- Most of computations are done within about 2 clock cycles for numbers less than decimal values = 200
