# IEEE Single Precision Floating Point Arithmetic Unit Design

Floating point arithmetic is a fundamental requirement in digital signal processing, control systems, and embedded computing platforms. This project focused on the complete design, verification, and FPGA implementation of an IEEE-754 compliant 32-bit single precision Floating Point Unit (FPU).

The implemented FPU supports:

* Floating point addition and subtraction
* Floating point multiplication and division using reciprocal LUT approximation
* IEEE-754 rounding modes and exception handling

The design emphasizes modularity, correctness, and reusability

## IEEE-754 Single Precision Format

**Format Overview**

A single precision floating point number consists of:
* 1-bit sign
* 8-bit exponent with bias 127
* 23-bit fraction with an implicit leading one

**Exception Handling**

The following IEEE-754 exception flags are generated:
* Invalid operation
* Divide-by-zero
* Overflow
* Underflow
* Inexact

## Overall Architecture and Design Flow

The overall design flow followed:

1. IEEE-754 specification analysis
2. Algorithm derivation and validation
3. RTL modularization
4. FSM-based datapath control
5. Simulation-based verification
6. UART-based system testing
7. FPGA synthesis and implementation

I first created the definition package according to IEEE format and helper packages for operations: leading zero counter, pack, unpack, reciprocal calculator, round, shift and handeling special cases. These helper modules were simulated and validated in Vivado.

Then the main functional modules were designed in RTL and simulated. Addition and substraction shares the same addsub unit. Multiplication and division also share the same module where for the division, the reciprocal is taken using LUT-based method and fed to the multiplication unit. All modules were initially designed as ASMs and converted to RTL designs in Vivado. The RTLs were simulated and verified, synthesized and finally tested on FPGA hardware. A top level module was created to take input from the PC via UART, communicate with the FPU unit in the FPGA, and finally send the output back to the PC user interface.

FPGA resource utilization after synthesis was 11% LUT, 3% Flip flops, 13% DSP, and 4% Input/Output. Power consumption analysis showed 103 mW total on-chip power usage. 

Repository link [https://github.com/NilaknaW/sp-fp-arithmetic-unit](https://github.com/NilaknaW/sp-fp-arithmetic-unit)


## Conclusion
Afully IEEE-754 compliant single precision floating point unit was successfully designed, verified, and implemented. The modular architecture, FSM-based control, and LUT based division enabled correctness, scalability, and efficient FPGA deployment.
Future work includes pipelining, higher precision formats, and performance optimization.

