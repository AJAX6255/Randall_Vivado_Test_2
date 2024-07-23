# Digital Clock Design Using Basys 3 Board

This repository contains the Verilog code and related files for designing a digital clock in a 24-hour format, implemented and demonstrated using the Basys 3 FPGA board. The project is part of the Digital Electronic Circuits Lab (EC2P004) course at IIT Bhubaneswar.

## Features

- **Second, Minute, and Hour Counting:** The clock counts seconds, which cascade to minutes and hours.
- **12/24-Hour Format Toggle:** Option to toggle between 12-hour and 24-hour formats.
- **Reset and Set Time Functionality:** The clock can be reset to zero and set to any desired time in HHMMSS format.
- **Time Display:** The current time is displayed in HHMM or MMSS format on the Basys 3 board using four 7-segment displays.
- **Stopwatch:** A stopwatch feature is included for time tracking.
- **Simulation and Testing:** The design is tested and simulated using open-source tools like Icarus Verilog (iverilog) and GTKWave to verify the waveforms.
- **Bonus Features:** Additional features such as an alarm (indicated by a blinking LED) are also implemented.

## Tools Used

- **Vivado:** For synthesis and implementation of the design on the Basys 3 board.
- **Icarus Verilog:** For simulating the Verilog code.
- **GTKWave:** For viewing simulation waveforms.

## How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/ayush1108g/DigitalClock_vivado.git
   ```
2. Open the project in Vivado.
3. Synthesize, implement, and generate the bitstream.
4. Program the Basys 3 board with the generated bitstream.
5. Use the onboard buttons to reset or set the clock time.
