# Testbenches and Waveforms — AQUILA

This directory contains the Verilog testbenches used to exercise the AQUILA RTL and the saved VCD waveforms from the recorded simulations. Testbenches provide a controlled simulation environment: they apply input sequences to a design-under-test (DUT), observe outputs, and check expected behavior.

## 1. Testbench inventory

| Testbench | DUT / scope |
|---|---|
| `tb_water_pump_controller.v` | Integrated top-level controller. |
| `tb_pump_fsm.v` | Pump-control FSM. |
| `tb_flow_timer.v` | Flow timer. |
| `tb_restart_timer.v` | Restart timer. |

The matching text logs are stored in [`../verification_results/`](../verification_results/). Saved waveform files use the `.vcd` extension.

## 2. Why both unit-level and top-level tests matter

**Module-level tests** isolate one block so its behavior can be inspected without all of the surrounding controller logic. They are useful for debugging state transitions and timer boundary conditions.

**Top-level tests** exercise the integration of the modules. They can reveal problems caused by signal connections, reset sequencing, or interactions that may not appear when each module is tested alone.

Passing a module-level test does not automatically prove that the integrated controller is correct. Both levels should be rerun after relevant changes.

## 3. Run the top-level testbench with Icarus Verilog

From the repository root, compile the top-level testbench and its RTL dependencies:

```bash
iverilog -g2012 -o /tmp/water_pump_sim \
  src/water_pump_controller.v \
  src/pump_fsm.v \
  src/flow_timer.v \
  src/restart_timer.v \
  tb/tb_water_pump_controller.v

vvp /tmp/water_pump_sim
```

The output executable is placed in `/tmp`, avoiding a generated binary in the repository. The command assumes Icarus Verilog is installed and that the testbench's current module dependencies match the listed source files.

For module-level tests, compile the corresponding testbench with the RTL module it instantiates. Include any dependencies required by that module. For example, if a testbench instantiates another module not listed on the command line, Icarus Verilog will report an unresolved module; add the missing source file and rerun.

## 4. View a saved VCD waveform

GTKWave can open a waveform file:

```bash
gtkwave tb/tb_water_pump_controller.vcd
```

Within GTKWave, add the signals of interest to the waveform pane and inspect their values over time. Useful review targets include clock/reset behavior, state changes, timer count activity, completion signals, and top-level outputs—where those signals are present in the recorded VCD.

A VCD only contains signals and time intervals recorded by the simulation. If a signal is missing, confirm that it was dumped by the testbench before assuming that the design did not generate it.

## 5. What a robust testbench should check

When extending these testbenches, consider the following categories where applicable:
- Reset assertion and release.
- Normal operating sequences.
- State transitions at each documented boundary.
- Timer start, stop, clear, and terminal-count behavior.
- Counter rollover or maximum values.
- Unexpected or changing inputs during a timed operation.
- Restart-delay behavior and attempts to restart before/after completion.
- Output stability and response latency.
- Repeated sequences, not only a single successful cycle.

These are recommended test categories. The existing testbenches should be inspected to determine which are already covered.

## 6. Logs and evidence

The recorded logs are in [`../verification_results/`](../verification_results/). A PASS message is evidence only for the checks that the testbench actually executes. When the RTL or testbench changes, rerun the test and refresh its log so that the repository does not present stale results as current.

The committed testbench and waveform artifacts document RTL simulation. They should not be described as gate-level simulation, formal verification, or hardware validation unless separate evidence for those activities is added.
