# Supporting Project Artifacts

This directory groups project files that support the RTL and testbench source but are not part of the primary RTL source tree.

## Directory

### [`physical_design/`](physical_design/)

Contains selected outputs and reports from the recorded OpenLane RTL-to-GDSII implementation run, including:
- GDSII layout database.
- Routed DEF design representation.
- Extracted SPEF parasitic data.
- Final summary CSV.
- Synthesized Verilog netlist.
- Timing, antenna, and LVS-related reports.

The artifacts should be interpreted using the reports and constraints that generated them. See [`physical_design/README.md`](physical_design/README.md) for the recorded metrics and important caveats.
