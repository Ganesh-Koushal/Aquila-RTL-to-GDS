# Synthesized Verilog Netlist

This directory contains the synthesized netlist for the AQUILA water-pump controller.

## File

`water_pump_controller.synthesis.v` is the synthesized Verilog netlist produced during the recorded OpenLane run. Synthesis transforms the RTL representation into a netlist mapped to cells supported by the target platform and synthesis configuration.

## How it relates to the RTL

The original RTL is located in [`../../../../src/`](../../../../src/). The synthesized netlist is a downstream implementation artifact and may differ substantially in structure from the RTL because synthesis can optimize logic, infer or transform structures, and map logic to library cells.

Use the netlist to inspect the synthesized implementation, not as a replacement for the source RTL or as proof of simulation coverage.

## Important distinction

The presence of a synthesized netlist does not establish that gate-level simulation was run. If gate-level simulation is added later, document the simulation setup, cell models, testbench, run logs, and results separately.
