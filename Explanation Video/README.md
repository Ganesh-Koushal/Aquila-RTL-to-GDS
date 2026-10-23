# AQUILA Project Explanation Video

This directory is reserved for information about the AQUILA project walkthrough video. Add the verified video URL here if the video is hosted externally, and confirm that reviewers have permission to view it. Do not invent or publish an unverified link.

## Recommended walkthrough structure

A clear technical walkthrough can follow this order:

1. **Problem and objective** — introduce the water-pump controller concept and the scope of the digital implementation.
2. **RTL architecture** — explain the top-level controller and the roles of `pump_fsm`, `flow_timer`, and `restart_timer`.
3. **RTL source tour** — show how the modules are organized and how the timing constraints are provided.
4. **Verification** — introduce the four testbenches, representative simulation logs, and VCD waveforms.
5. **Synthesis** — show the synthesized netlist and synthesis results.
6. **Physical implementation** — walk through floorplanning, placement, CTS, routing, and the final GDSII layout.
7. **Results and caveats** — discuss the recorded area/cell metrics, the path-specific timing result, the LVS summary, and the antenna violation.
8. **Future work** — explain the tests, documentation, and physical checks that could be improved next.

## Reviewer resources

- Main documentation: [`../README.md`](../README.md)
- RTL source: [`../src/`](../src/)
- Testbenches: [`../tb/`](../tb/)
- Physical-design reports: [`../other_files/physical_design/reports/`](../other_files/physical_design/reports/)

The video should describe the project accurately and distinguish RTL simulation from gate-level simulation or hardware validation.

