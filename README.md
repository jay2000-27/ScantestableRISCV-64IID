Scan-Testable RISC-V RV64I Instruction Decoder on FPGA

Master's thesis project developed as part of the "M.Eng. Electrical Engineering and Embedded Systems" program at Ravensburg-Weingarten University of Applied Sciences.

The project investigates whether **Design for Testability (DFT)** concepts can be applied directly at the component level of a processor rather than only at the top level.

The selected Design Under Test (DUT) is a "RISC-V RV64I instruction decoder" implemented in VHDL. To make the decoder scan-testable, the project integrates:

- a custom RV64I instruction decoder,
- input and output scan registers,
- a reduced JTAG/TAP controller,
- an instruction register and bypass register,
- and scan-chain control logic.

The complete design was developed and simulated using "VHDL and Xilinx Vivado".

---

Project Objectives

The main objectives of the project were:

1. Design and implement an RV64I instruction decoder.
2. Verify the decoder using a VHDL testbench.
3. Design a reduced JTAG/TAP architecture suitable for controlling the test logic.
4. Design and verify scan-register functionality.
5. Integrate the decoder, scan registers, and JTAG control logic.
6. Investigate the feasibility of applying scan-based DFT directly to an internal processor component.

THESIS DOCUMENT: https://drive.google.com/file/d/1YRIb74eRsxAzlaz9V3m9CCKcMCbD9Pwx/view?usp=drive_link
