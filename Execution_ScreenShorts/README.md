# AQUILA Execution Screenshots

This directory contains visual evidence from selected stages of the AQUILA RTL-to-GDSII project. The screenshots are intended to help reviewers quickly understand the work and navigate the more detailed source files and reports.

## Screenshot categories

The directory includes images documenting:
- RTL simulation results and selected signal waveforms.
- Synthesis results and synthesized-netlist views.
- Floorplan and die-area views.
- Standard-cell placement.
- Clock-tree synthesis (CTS).
- Detailed routing.
- GDSII layout views.
- Timing-analysis results.
- LVS-related output.

Individual image filenames identify the view or stage they illustrate. Use the screenshots as a visual guide rather than as the sole source of technical truth.

## Where to find supporting evidence

- RTL source: [`../src/`](../src/)
- Testbenches and VCD waveforms: [`../tb/`](../tb/)
- Simulation logs: [`../verification_results/`](../verification_results/)
- Physical-design artifacts and machine-readable reports: [`../other_files/physical_design/`](../other_files/physical_design/)

For numerical values and signoff-related interpretation, use the original reports. The recorded implementation artifacts include a path-specific positive-slack timing report, an LVS summary with zero reported mismatches, and an antenna report with one violation. Screenshots should not be used to imply stronger results than the underlying reports support.
