# RTL Source Directory — AQUILA

This directory contains the Verilog RTL modules and SDC constraints for the AQUILA water-pump controller. It is the starting point for understanding the design before running simulations or examining the physical-design outputs.

## 1. Source inventory

| File | Description |
|---|---|
| `water_pump_controller.v` | Top-level RTL integration module. |
| `pump_fsm.v` | Pump-control finite-state-machine module. |
| `flow_timer.v` | Flow-timer logic used by the controller. |
| `restart_timer.v` | Restart-delay timer logic. |
| `water_pump_controller.sdc` | Timing constraints used by the implementation flow. |

Open the RTL files for the authoritative port names, signal polarities, reset conventions, state definitions, counter widths, and terminal-count behavior. This document explains the module organization but does not replace the source.

## 2. Top-level integration: `water_pump_controller.v`

The top-level module defines the controller's interface and connects the supporting modules. It is the best starting point for following how the complete design is assembled.

When reviewing this file, trace:
1. The top-level input and output ports.
2. The clock and reset signals and their active levels.
3. Instances of `pump_fsm`, `flow_timer`, and `restart_timer`.
4. Inter-module control and status signals.
5. The conditions under which the top-level outputs change.

Use `tb/tb_water_pump_controller.v` to see how the integrated design is stimulated and checked. Avoid assuming that a signal or condition exists unless it is present in the source.

## 3. Pump-control state machine: `pump_fsm.v`

An FSM expresses sequential control as states and transitions. In this design, the pump FSM is separated from timer implementation so its decision logic can be inspected and tested independently.

For a technical review, identify the following in the source:
- State declarations and encoding.
- State register and reset behavior.
- Next-state transition conditions.
- Output decoding and whether outputs are registered or combinational.
- Any assumptions about synchronous inputs.
- Default or recovery behavior for unrecognized state values, if implemented.

The dedicated testbench is `tb/tb_pump_fsm.v`; the associated VCD waveform is stored in `tb/`. The testbench and waveform are the best way to understand the scenarios actually exercised.

## 4. Flow timer: `flow_timer.v`

This module encapsulates timer/counter behavior used by the controller. Timer logic is sensitive to clocking, reset, enable conditions, counter width, and the exact terminal-count comparison.

When examining or modifying the timer, verify:
- When counting begins and stops.
- Whether the counter clears on reset, disable, or completion.
- Whether the terminal count is inclusive or exclusive.
- Whether the completion indication is a level or a pulse.
- Whether the count width can represent the intended range.
- Whether simultaneous control conditions have a defined priority.

These are review questions, not assumptions about implementation. The source and `tb/tb_flow_timer.v` determine the actual behavior.

## 5. Restart timer: `restart_timer.v`

The restart timer encapsulates delay-related logic associated with restarting the pump controller. Isolating this behavior makes it easier to test the delay mechanism independently from the FSM.

Review its counter operation, start/clear conditions, reset behavior, terminal-count condition, and output semantics. Use `tb/tb_restart_timer.v` to see the tested scenarios and the corresponding waveform in `tb/`.

## 6. Timing constraints: `water_pump_controller.sdc`

The SDC file communicates timing assumptions to the implementation and timing-analysis tools. Clock definitions, clock periods, input/output delays, and exceptions—if present—affect the timing checks performed by the flow.

Before changing timing targets:
1. Read the actual SDC commands.
2. Confirm the intended clock period and clock port.
3. Check whether input and output delays represent the intended environment.
4. Confirm that any false paths or multicycle paths, if present, are justified.
5. Re-run timing analysis after changing constraints.

A timing report is meaningful only in the context of the constraints used to produce it.

## 7. Configuration files

The flow configuration is stored at the repository root:
- [`../config.tcl`](../config.tcl)
- [`../sky130A_sky130_fd_sc_hd_config.tcl`](../sky130A_sky130_fd_sc_hd_config.tcl)

These files configure the OpenLane run and platform/design settings. Paths may be environment-specific. Review them before reproducing the flow on a different machine or installation.

## 8. Recommended RTL change workflow

1. Identify the module and behavior being changed.
2. Update the RTL while keeping its interface consistent with its callers.
3. Compile and run the module's testbench.
4. Inspect the generated waveform for reset, transition, and boundary behavior.
5. Run the top-level testbench to check integration.
6. Update the corresponding verification log only after rerunning the simulation.
7. If the change affects area or timing, rerun synthesis/implementation and inspect the new reports.

## 9. Related project resources

- [`../tb/`](../tb/) — testbench source and VCD waveforms.
- [`../verification_results/`](../verification_results/) — logs from recorded RTL simulations.
- [`../other_files/physical_design/`](../other_files/physical_design/) — selected netlist, GDSII, DEF, SPEF, and reports.

The RTL and SDC files are the source of truth for design behavior and timing assumptions.
