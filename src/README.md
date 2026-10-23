# RTL Source Code

This directory contains the synthesizable Verilog RTL and timing constraints for **AQUILA — Intelligent Water Pump Controller**.

## Design organization

| File | Purpose |
|---|---|
| `water_pump_controller.v` | Top-level controller that integrates the design modules. |
| `pump_fsm.v` | Pump-control finite-state-machine logic. |
| `flow_timer.v` | Timer/counter logic used by the controller. |
| `restart_timer.v` | Restart-delay timer logic. |
| `water_pump_controller.sdc` | Timing constraints supplied to the implementation flow. |

The exact interface signals, reset behavior, state transitions, counter limits, and timer parameters are defined in the source files. Read the RTL alongside the testbenches in [`../tb/`](../tb/) to understand and validate the intended behavior.

## Design hierarchy

The intended hierarchy is centered on `water_pump_controller`, which integrates `pump_fsm`, `flow_timer`, and `restart_timer`. Confirm the actual instantiations and port connections in the Verilog source when modifying the design.

## Configuration

The OpenLane configuration files are located at the repository root:

- [`../config.tcl`](../config.tcl)
- [`../sky130A_sky130_fd_sc_hd_config.tcl`](../sky130A_sky130_fd_sc_hd_config.tcl)

The SDC file contains the timing constraints used by the flow. Review the clock definition and any input/output delay assumptions before changing the target clock or using the design in another environment.

## Editing guidelines

1. Keep each module's interface and reset semantics consistent with its testbench.
2. When changing timer widths or terminal counts, update tests to cover boundary values.
3. Re-run the relevant module testbench and the integrated top-level testbench after RTL changes.
4. Review synthesis and timing reports after changes that affect logic depth, state encoding, or counter size.
5. Keep generated binaries out of version control; preserve useful `.vcd` files when they are intentionally included for review.

## Related directories

- [`../tb/`](../tb/) — testbench source and saved waveforms.
- [`../verification_results/`](../verification_results/) — checked-in RTL simulation logs.
- [`../other_files/physical_design/`](../other_files/physical_design/) — selected synthesis and physical-design artifacts.

This README describes the organization of the source directory. The Verilog source and constraints remain the authoritative definitions of the design.
