# Digital Clock Design Using Basys 3 Board

This repository contains the Verilog code and related files for designing a digital clock in a 24-hour format, implemented and demonstrated using the Basys 3 FPGA board.

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
   git clone [(https://github.com/AJAX6255/Randall_Vivado_Test_2/blob/main/README.md)]
   ```
2. Open the project in Vivado.
3. Synthesize, implement, and generate the bitstream.
4. Program the Basys 3 board with the generated bitstream.
5. Use the onboard buttons to reset or set the clock time.
---------------------------------------------------------------------
## Project Files Explanation

This section describes each of the files and folders generated in the Vivado project for the **DigitalClock**. These files are essential for the synthesis, implementation, and management of the project in Vivado.

- **DigitalClock_vivado.cache/wt**  
  This folder contains Vivado's internal cache files, which store data that helps speed up loading and saves information about project state.

- **project.wpc**  
  This file contains Vivado workspace settings, such as project layout and tool configurations.

- **synthesis.wdf & synthesis_details.wdf**  
  These files store synthesis data and additional synthesis details generated by Vivado. They contain intermediate synthesis information, used during the process of converting the HDL code into a hardware description.

- **webtalk_pa.xml**  
  This XML file logs information for Vivado’s WebTalk feature, which collects tool usage data for support and improvement purposes.

- **DigitalClock_vivado.hw & hw_1**  
  The `DigitalClock_vivado.hw` file and `hw_1` directory store hardware-specific configuration data and resources used during the hardware programming phase, including data needed for debugging and implementation on physical hardware.

- **DigitalClock_new.lpr**  
  This is a Vivado-generated log file that contains data about the project's synthesis, implementation, and any logged activity.

- **DigitalClock_vivado.runs**  
  This folder contains run directories for synthesis (`synth_1`) and implementation (`impl_1`). Each subdirectory holds data and intermediate files generated during the synthesis and implementation processes.

- **.jobs**  
  The `.jobs` folder is a temporary directory that contains data about background processing jobs running in Vivado.

- **impl_1 & synth_1**  
  These directories contain synthesized and implemented design files respectively. `synth_1` holds data files related to the synthesis stage, while `impl_1` contains files for the implementation stage, which is where Vivado maps the design to actual hardware resources.

- **DigitalClock_vivado.srcs**  
  The `DigitalClock_vivado.srcs` folder contains all the source files and constraints associated with the project, including HDL source code, block diagrams, and imported files.

- **constrs_1/imports/basys3_constrain.xdc**  
  This is a constraints file in XDC format, specifying hardware constraints for the Basys 3 FPGA board, such as pin assignments, timing requirements, and other design rules.

- **sources_1/new**  
  This folder contains HDL source files and other new files that have been added to the project’s source group, categorized by Vivado for organization within the project structure.

- **utils_1/imports/synth_1**  
  This directory contains synthesis utility files imported into the project, which may include additional modules, libraries, or helper scripts.

- **.gitattributes**  
  The `.gitattributes` file is used to manage Git attributes and configure behaviors specific to file types within the repository. It can control handling of text encoding, line endings, and more for collaboration.

- **DigitalClock_vivado.xpr**  
  This is the main project file for Vivado, which stores the project configuration and tracks all associated files. Opening this file in Vivado will load the entire project structure.

