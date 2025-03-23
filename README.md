# Timer Circuit for Digilent Basys3 FPGA Development Board

## Overview
This project implements a timer circuit on the Digilent Basys3 FPGA development board. The circuit counts up to 60 seconds and displays the elapsed time using the onboard 7-segment displays. The RTL code and testbenches are written in VHDL. 

## Features
- Counts from 00.00 to 59.99 seconds
- Uses enable generators to generate the clocks for individual displays from the main clock
- Displays the time on the 7-segment display using a BCD to 7-degment decoder
- Synchronous active high reset to restart the timer

## Functional Description
1. **BCD Counter:** Each segment is clocked individually using an enable generator to generate precise clocks from the main clock.
2. **Clock Logic:** Each counter is programmed to operate at a different frequency in order to drive the clock, with the first digit counting from 0-5 and the remaining ones from 0-9.
3. **7-Segment Display Control:** The timer value is displayed on the 4-digit 7-segment display.

## Usage Instructions
The circuit was designed using the Vivado Design Suite and includes a file for building the project and programming the board.

## Building
1. Clone this repository:
   ```
   git clone https://github.com/monde-lointain/fpga_timer.git
   ```
2. Open Vivado in TCL mode and read the script file in:
   ```
   vivado -mode tcl -source scripts.tcl
   ```
3. Run the following command to synthesize, implement and generate the bitstream, and then program the board:
   ```
   compile_and_program
   ```

## Controls
- **btnU**: Reset the timer