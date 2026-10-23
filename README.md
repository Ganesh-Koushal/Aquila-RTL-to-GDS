# AQUILA — Intelligent Water Pump Controller

### A Verilog-Based RTL-to-GDSII ASIC Design Using OpenLane and Sky130A

<p align="center">

**From RTL Design to Physical Silicon Layout**

*Finite State Machines • Sequential Logic • RTL Verification • Logic Synthesis • Static Timing Analysis • Physical Design*

</p>

---

## 📌 Project Overview

**AQUILA — Intelligent Water Pump Controller** is a digital hardware design project that implements the control logic for a water-pump application using Verilog HDL and takes the design through an ASIC implementation flow from Register-Transfer Level (RTL) to the final GDSII layout.

The project focuses on the design and implementation of a modular digital controller incorporating finite-state-machine-based pump control, timer functionality, and restart-delay logic. The RTL is organized into independent functional modules, verified through dedicated simulation testbenches, and processed using **OpenLane with the Sky130A standard-cell platform**.

Unlike a project that stops after writing Verilog and observing a simulation waveform, AQUILA extends into the physical-design domain. The workflow includes RTL development, simulation, synthesis, floorplanning, placement, clock-tree synthesis, routing, parasitic extraction, timing analysis, and the generation of a final GDSII layout database.

The repository preserves the project's RTL source code, testbenches, simulation waveforms, verification logs, configuration files, synthesized netlist, physical-design outputs, reports, and screenshots documenting the implementation process.

The objective is to demonstrate a complete digital-design workflow while developing practical familiarity with the tools and concepts used in ASIC design and implementation.

> **Project identity:** AQUILA — Intelligent Water Pump Controller
> **Design methodology:** RTL-based digital design and ASIC implementation
> **Hardware description language:** Verilog HDL
> **Implementation flow:** OpenLane
> **Target technology platform:** Sky130A
> **Standard-cell library:** `sky130_fd_sc_hd`
> **Final layout format:** GDSII

---

## 🎯 1. Problem Statement and Motivation

Water-pump control is a useful application for studying digital control systems because it involves sequential decision-making, timing behavior, and interactions between control logic and external operating conditions.

A controller for such an application may need to coordinate pump operation, track control states, handle timing intervals, and manage restart behavior. Implementing these functions in digital hardware requires more than basic combinational logic: it requires sequential circuits, state management, counters, reset behavior, and clearly defined transitions between operating conditions.

AQUILA approaches this problem by dividing the controller into modular RTL blocks.

The pump-control finite state machine handles control-state behavior, while separate timer modules provide timing functionality. A top-level module integrates these components into a single design.

This organization supports independent testing, improves readability, and makes the design easier to maintain and extend.

### Project objectives

The major objectives of AQUILA are:

* Design a modular digital controller using Verilog HDL.
* Implement pump-control behavior using finite-state-machine logic.
* Develop separate timer modules for flow timing and restart-delay functionality.
* Integrate the modules into a top-level controller.
* Verify the RTL using dedicated testbenches and simulation waveforms.
* Understand the transition from behavioral RTL to a synthesized standard-cell netlist.
* Execute an RTL-to-GDSII implementation flow using OpenLane.
* Examine physical-design stages such as floorplanning, placement, clock-tree synthesis, and routing.
* Analyze implementation outputs, including timing, parasitic, layout, and LVS-related reports.
* Preserve the design artifacts and results in a structured GitHub repository.

The project therefore combines **digital logic design, RTL verification, and ASIC physical implementation** in a single engineering workflow.

---

## ⚙️ 2. Design Concept and Functional Organization

AQUILA is organized around four principal RTL modules:

| Module                  | Primary responsibility                  |
| ----------------------- | --------------------------------------- |
| `water_pump_controller` | Top-level integration of the controller |
| `pump_fsm`              | Pump-control finite-state-machine logic |
| `flow_timer`            | Flow-timer functionality                |
| `restart_timer`         | Restart-delay timing functionality      |

Each module represents a separate functional part of the design.

This separation allows the supporting logic to be tested individually before the integrated controller is evaluated.

### 2.1 Top-level controller

The top-level module, `water_pump_controller.v`, acts as the integration point for the design.

It connects the relevant functional blocks and defines the controller's external interface. Its implementation determines how the FSM and timer modules interact, how control signals are connected, and how the integrated design responds to its inputs.

The top-level module is also the natural entry point for synthesis and physical implementation.

### 2.2 Pump-control finite state machine

The `pump_fsm.v` module implements the controller's pump-control state-machine logic.

A finite state machine represents sequential control using states and transitions. The current state and relevant inputs determine the next state and associated control behavior.

Separating the FSM from the timer logic makes the control structure easier to inspect and allows the state-machine behavior to be tested independently.

This modular approach is particularly useful when debugging transitions, examining reset behavior, or extending the control sequence.

### 2.3 Flow timer

The `flow_timer.v` module implements timer/counter functionality used by the controller.

Timer logic introduces sequential behavior into the design. Its implementation depends on the clock, reset and control conditions, counter width, and terminal-count behavior defined in the RTL.

Keeping the timer in a separate module allows its operation to be tested independently of the complete controller.

### 2.4 Restart timer

The `restart_timer.v` module implements restart-delay timing functionality.

Restart-related timing is an important consideration in controllers that need to coordinate operation across time intervals. Isolating this functionality makes it easier to inspect the counter behavior and evaluate the module independently.

The precise timing conditions, counter limits, and signal behavior are defined by the Verilog implementation and should be interpreted alongside the corresponding testbench.

### 2.5 Why a modular architecture?

The modular organization offers several engineering benefits:

* **Separation of concerns:** Control-state logic and timer functionality are represented in separate modules.
* **Independent verification:** Each module has its own dedicated testbench.
* **Improved readability:** The design is easier to navigate than a single large RTL block.
* **Simpler debugging:** Problems can be investigated at the module level before examining the integrated system.
* **Maintainability:** Individual components can be modified with a clearer understanding of their interfaces.
* **Reusable design practices:** The same modular methodology applies to larger digital-control systems.

The RTL source files define the exact signal interfaces, reset semantics, state transitions, and timer behavior. These implementation details are the authoritative reference for understanding the controller.

---

## 🧠 3. RTL Design and Verilog Implementation

The design was described using Verilog HDL.

RTL describes a digital circuit in terms of registers, combinational logic, sequential behavior, and interactions between functional blocks. Synthesis tools interpret this description and transform it into a gate-level implementation using cells available in the target technology library.

For AQUILA, the RTL was divided into four principal modules rather than placing the entire design in one source file.

### Source files

| File                            | Description                           |
| ------------------------------- | ------------------------------------- |
| `src/water_pump_controller.v`   | Top-level controller                  |
| `src/pump_fsm.v`                | Pump-control FSM                      |
| `src/flow_timer.v`              | Flow-timer module                     |
| `src/restart_timer.v`           | Restart-timer module                  |
| `src/water_pump_controller.sdc` | Timing constraints for implementation |

The top-level RTL integrates the functional modules, while the supporting modules encapsulate their respective control and timing responsibilities.

The design was then prepared for simulation and for processing by the OpenLane flow.

### Design considerations

Several aspects of RTL design are important when developing this type of controller:

**Sequential behavior:** State registers and counters must respond consistently to clock and reset conditions.

**State transitions:** FSM behavior must be defined clearly so that control decisions are predictable for the tested input sequences.

**Timer behavior:** Counter widths, terminal counts, enable conditions, and reset behavior affect the timing logic.

**Module interfaces:** Signal connections between the top-level controller and its supporting modules must be consistent.

**Synthesis compatibility:** RTL must be suitable for the synthesis flow and supported by the target standard-cell platform.

**Timing constraints:** The SDC file provides timing assumptions that influence timing analysis during implementation.

These considerations become increasingly important as a design progresses from RTL simulation into synthesis and physical implementation.

---

## 🧪 4. RTL Verification and Functional Simulation

Simulation was used to exercise the RTL before examining the physical implementation.

The project contains four dedicated Verilog testbenches, covering both the integrated controller and its supporting modules.

| Testbench                       | Verification target  |
| ------------------------------- | -------------------- |
| `tb/tb_water_pump_controller.v` | Top-level controller |
| `tb/tb_pump_fsm.v`              | Pump-control FSM     |
| `tb/tb_flow_timer.v`            | Flow timer           |
| `tb/tb_restart_timer.v`         | Restart timer        |

The corresponding simulation logs are stored in `verification_results/`, and the repository preserves VCD waveform files in `tb/`.

### 4.1 Module-level verification

The individual testbenches allow the functional blocks to be exercised independently.

This is useful because an isolated test can focus on one module's behavior without requiring every part of the complete controller to operate simultaneously.

For example, the FSM testbench focuses on the pump-control state-machine module, while the timer testbenches focus on their respective timing blocks.

Independent tests help narrow down the source of a problem when a particular module behaves unexpectedly.

### 4.2 Top-level verification

The top-level testbench evaluates the integrated controller.

Testing the complete module is important because correct individual components do not automatically guarantee correct system integration. Inter-module connections and interactions can introduce problems that are not visible in isolated tests.

The top-level testbench therefore provides a separate way to exercise the integrated design.

### 4.3 Simulation logs

The repository contains the following recorded logs:

* `verification_results/water_pump_controller.log`
* `verification_results/pump_fsm.log`
* `verification_results/flow_timer.log`
* `verification_results/restart_timer.log`

These files preserve the output of the available testbench runs.

The logs should be read alongside their corresponding testbenches because the testbench determines which inputs are applied and which results are checked.

### 4.4 Waveform analysis

Value Change Dump files preserve signal transitions over the recorded simulation interval.

The available waveform files include:

* `tb/tb_water_pump_controller.vcd`
* `tb/tb_pump_fsm.vcd`
* `tb/tb_flow_timer.vcd`
* `tb/tb_restart_timer.vcd`

These waveforms can be opened using GTKWave to inspect signal activity over simulation time.

Waveform inspection provides a visual way to examine the recorded behavior of the controller and its supporting modules.

### 4.5 Reproducing the top-level simulation

With Icarus Verilog installed, the top-level simulation can be compiled from the repository root using:

```bash
iverilog -g2012 -o /tmp/water_pump_sim \
  src/water_pump_controller.v \
  src/pump_fsm.v \
  src/flow_timer.v \
  src/restart_timer.v \
  tb/tb_water_pump_controller.v
```

Run the compiled simulation with:

```bash
vvp /tmp/water_pump_sim
```

To inspect a saved waveform:

```bash
gtkwave tb/tb_water_pump_controller.vcd
```

The individual testbenches can be compiled similarly, including their corresponding RTL modules and any required dependencies.

### Verification scope

The committed testbenches, logs, and waveforms document the available RTL simulation work.

They should not be interpreted as proof of exhaustive functional coverage, formal verification, gate-level simulation, or physical hardware validation. Those activities require their own methods and supporting evidence.

---

## 🏗️ 5. RTL-to-GDSII ASIC Implementation

One of the central parts of AQUILA is its progression beyond RTL simulation into physical implementation.

The design was processed through **OpenLane**, targeting the **Sky130A standard-cell platform** and its `sky130_fd_sc_hd` library.

The recorded run is identified as:

`23-10_15-37`

The flow generated a GDSII layout and several supporting implementation artifacts.

### Why RTL-to-GDSII implementation matters

RTL simulation evaluates the behavior of a digital design in a simulated environment. Physical implementation addresses a different question: how the synthesized design is mapped and arranged using the resources and rules of a target semiconductor technology.

An RTL-to-GDSII flow connects logical design with physical realization.

The process involves several stages, each with a different purpose.

### 5.1 Configuration and timing constraints

The implementation begins with the design RTL, flow configuration, target platform, and timing constraints.

The project includes:

* `config.tcl`
* `sky130A_sky130_fd_sc_hd_config.tcl`
* `src/water_pump_controller.sdc`

These files provide configuration and constraint information used by the implementation environment.

The actual configuration determines how the flow interprets the design, which platform resources it uses, and which timing assumptions apply.

### 5.2 Logic synthesis

Synthesis transforms the RTL into a technology-mapped standard-cell netlist.

At this stage, the behavioral description is converted into a representation suitable for implementation using cells supported by the target platform.

The repository preserves the synthesized netlist at:

`other_files/physical_design/netlists/water_pump_controller.synthesis.v`

The synthesized netlist is useful for examining the implementation produced by synthesis. It is distinct from the original RTL and does not, by itself, establish that gate-level simulation has been performed.

### 5.3 Floorplanning

Floorplanning establishes the initial physical organization and planning constraints for the design.

It defines the implementation area and establishes the framework within which cells and routing resources are arranged.

The project screenshots include floorplan and die-area views that help visualize this stage.

### 5.4 Standard-cell placement

Placement determines the physical locations of the standard cells within the floorplan.

The objective is to arrange the cells in a manner compatible with the implementation constraints and the subsequent routing process.

The repository includes screenshots documenting placement-related stages.

### 5.5 Clock-tree synthesis

Clock-tree synthesis constructs the clock distribution network where required by the flow.

Clock distribution is an important aspect of sequential digital design because clock signals must reach the relevant sequential elements while satisfying the implementation's timing and physical constraints.

The project includes a CTS screenshot documenting this stage of the recorded flow.

### 5.6 Routing

Routing creates the physical interconnections between the placed cells.

The resulting implementation includes routed signal connections and physical information describing the implemented design.

The repository preserves the routed DEF file at:

`other_files/physical_design/water_pump_controller.def`

The project screenshots also document detailed routing and related implementation views.

### 5.7 Parasitic extraction

Physical interconnects introduce parasitic resistance and capacitance that affect signal behavior and timing.

The implementation flow generated an SPEF artifact:

`other_files/physical_design/water_pump_controller.spef`

SPEF is used to represent extracted parasitic information for downstream analysis.

This artifact supports inspection of the implemented design beyond the original RTL and synthesized netlist.

### 5.8 Static timing analysis

Static timing analysis evaluates timing paths against the constraints supplied to the implementation flow.

The repository preserves an OpenSTA report at:

`other_files/physical_design/reports/24-opensta_spef.min_max.rpt`

The report contains an inspected path with:

| Timing parameter  | Reported value |
| ----------------- | -------------: |
| Data arrival time |        8.09 ns |
| Required time     |       19.85 ns |
| Slack             |      +11.76 ns |

The positive slack indicates that the reported path meets its stated timing requirement under the constraints used for that report.

**Important:** This is a path-specific result. It does not prove that every path meets timing or establish complete timing signoff for the design.

### 5.9 Physical verification and layout generation

The flow also generated reports associated with physical implementation checks, including antenna checking and LVS-related results.

The final layout database is preserved at:

`other_files/physical_design/water_pump_controller.gds`

GDSII is a standard format used to represent integrated-circuit layout geometry.

Generating the GDSII file represents an important deliverable of the recorded implementation flow. However, the presence of a GDSII file alone does not establish foundry signoff, fabrication, or validation on physical silicon.

---

## 📊 6. Recorded Implementation Results

The repository includes the summary file:

`other_files/physical_design/final_summary_report.csv`

The following values were recorded for the implementation run.

| Metric             |      Recorded result |
| ------------------ | -------------------: |
| Flow status        |     `Flow_completed` |
| Total runtime      | 2 minutes 24 seconds |
| Routed runtime     |  1 minute 50 seconds |
| Reported die area  |         0.011424 mm² |
| Cell count         |                  472 |
| OpenDP utilization |                  51% |
| Routed wire length |                15002 |
| Via count          |                 3456 |
| LVS total errors   |                    0 |
| CVC total errors   |                    0 |
| Antenna violations |                    1 |

These values are transcribed from the recorded summary report. Their definitions and units should be interpreted according to the originating flow reports.

### 6.1 Die area and cell count

The recorded summary reports a die area of `0.011424 mm²` and a cell count of `472`.

These metrics describe aspects of the physical implementation produced by the recorded flow.

Area and cell count depend on the RTL, synthesis results, target library, constraints, and implementation configuration. They should therefore be treated as results from this particular run rather than universal properties of the design.

### 6.2 Placement utilization

The summary reports an OpenDP utilization value of `51%`.

Utilization is associated with how the implementation area is used during placement. Its precise interpretation depends on the metric definition used by the flow.

### 6.3 Routing metrics

The summary records:

* Routed wire length: `15002`
* Via count: `3456`

These values describe aspects of the routed implementation. They should be interpreted using the original report's definitions and units.

### 6.4 Timing analysis

The included OpenSTA report records positive slack for the inspected path.

A timing report must be interpreted in the context of its constraints, path details, libraries, and extracted parasitic information.

A single positive-slack path is not equivalent to a complete timing-closure result. Further path coverage and the relevant timing summaries are needed to make broader claims about timing closure.

### 6.5 LVS result

The parsed LVS summary reports that the compared netlists match uniquely and reports no net, device, pin, or property mismatches.

The summary records zero total LVS errors.

This is evidence for the reported LVS comparison. It should not be expanded into a claim that every possible physical-design signoff check has passed.

### 6.6 Antenna result

The recorded antenna report indicates **one antenna violation**.

This result is important and is included explicitly rather than omitted from the project summary.

The recorded run should not be described as antenna-clean. Resolving the reported issue and rerunning the relevant checks would be a suitable next step if a clean antenna result is required.

---

## 🔍 7. Physical-Design Artifacts

AQUILA preserves selected machine-readable artifacts from the recorded OpenLane run.

| Artifact            | Repository path                                                                | Purpose                                |
| ------------------- | ------------------------------------------------------------------------------ | -------------------------------------- |
| Final GDSII         | `other_files/physical_design/water_pump_controller.gds`                        | Layout database                        |
| Routed DEF          | `other_files/physical_design/water_pump_controller.def`                        | Physical implementation representation |
| Extracted SPEF      | `other_files/physical_design/water_pump_controller.spef`                       | Parasitic information                  |
| Synthesized netlist | `other_files/physical_design/netlists/water_pump_controller.synthesis.v`       | Synthesized Verilog                    |
| Timing report       | `other_files/physical_design/reports/24-opensta_spef.min_max.rpt`              | Selected OpenSTA timing-path report    |
| Antenna report      | `other_files/physical_design/reports/41-antenna.rpt`                           | Antenna-check output                   |
| LVS summary         | `other_files/physical_design/reports/water_pump_controller.lvs_parsed.lef.log` | Parsed LVS result                      |
| Summary CSV         | `other_files/physical_design/final_summary_report.csv`                         | Recorded flow metrics                  |

These artifacts make the repository more useful than a screenshot-only portfolio because reviewers can inspect the underlying outputs.

The GDSII file can be opened in a compatible layout viewer such as KLayout. The other artifacts can be examined using tools that support their respective formats and the relevant design/platform context.

---

## 🖼️ 8. Implementation Screenshots

The `Execution_ScreenShorts/` directory contains screenshots documenting selected parts of the project.

The available images cover several aspects of the workflow, including:

* RTL simulation results.
* Individual-module and top-level waveforms.
* Synthesis results.
* Synthesized-netlist views.
* Floorplan and die-area views.
* Standard-cell placement.
* Clock-tree synthesis.
* Detailed routing.
* GDSII layout views.
* Timing-analysis output.
* LVS-related results.

These screenshots provide a visual walkthrough of the implementation process.

They complement the Verilog source, simulation logs, and machine-readable physical-design reports.

For numerical claims or detailed interpretation, the original reports should be treated as the authoritative evidence.

---

## 🧰 9. Tools and Technologies

The project brings together tools from several parts of the digital-design workflow.

| Tool / Technology | Role                                       |
| ----------------- | ------------------------------------------ |
| Verilog HDL       | RTL design                                 |
| Icarus Verilog    | RTL simulation                             |
| GTKWave           | VCD waveform inspection                    |
| OpenLane          | RTL-to-GDSII implementation flow           |
| Sky130A           | Target standard-cell platform              |
| `sky130_fd_sc_hd` | Target standard-cell library               |
| OpenSTA           | Static timing analysis                     |
| KLayout           | Layout visualization and inspection        |
| Git               | Source control                             |
| GitHub            | Project hosting and portfolio presentation |

The exact versions of tools and platform files are relevant to reproducibility. If the design is rerun in another environment, recording the tool versions and complete configuration would make the results easier to reproduce and compare.

---

## 📁 10. Repository Structure

The repository is organized to separate design source, simulation, results, and physical-design artifacts.

```text
Aquila-RTL-to-GDS/
│
├── README.md
│
├── config.tcl
├── sky130A_sky130_fd_sc_hd_config.tcl
│
├── src/
│   ├── README.md
│   ├── water_pump_controller.v
│   ├── pump_fsm.v
│   ├── flow_timer.v
│   ├── restart_timer.v
│   └── water_pump_controller.sdc
│
├── tb/
│   ├── README.md
│   ├── tb_water_pump_controller.v
│   ├── tb_pump_fsm.v
│   ├── tb_flow_timer.v
│   ├── tb_restart_timer.v
│   └── *.vcd
│
├── verification_results/
│   ├── README.md
│   ├── water_pump_controller.log
│   ├── pump_fsm.log
│   ├── flow_timer.log
│   └── restart_timer.log
│
├── other_files/
│   └── physical_design/
│       ├── README.md
│       ├── water_pump_controller.gds
│       ├── water_pump_controller.def
│       ├── water_pump_controller.spef
│       ├── final_summary_report.csv
│       │
│       ├── netlists/
│       │   └── water_pump_controller.synthesis.v
│       │
│       └── reports/
│           ├── 24-opensta_spef.min_max.rpt
│           ├── 41-antenna.rpt
│           └── water_pump_controller.lvs_parsed.lef.log
│
├── Execution_ScreenShorts/
│   └── README.md and screenshots
│
└── Explanation Video/
    └── README.md and video information
```

The structure separates the design's source code from its verification evidence and implementation outputs.

This makes it easier for a reviewer to navigate the project in a logical order: understand the RTL, inspect the testbenches, review simulation results, and then examine the physical implementation.

---

## 🚀 11. Challenges and Engineering Considerations

Taking an RTL project through an ASIC implementation flow involves several challenges beyond writing the source code.

### 11.1 Working with the implementation environment

An ASIC flow depends on its tool environment, configuration files, platform files, and library compatibility.

The project required configuring and working within the OpenLane environment so the RTL could be processed by the implementation flow.

This highlights the importance of understanding not only the design itself but also the software and technology environment required to implement it.

### 11.2 Connecting RTL results to physical outputs

Simulation and physical implementation produce different types of evidence.

RTL simulation is used to inspect functional behavior, whereas synthesis and physical-design tools generate implementation artifacts and reports.

Understanding how these stages relate is important when interpreting the final result.

### 11.3 Interpreting implementation reports

Physical-design reports must be interpreted in context.

The AQUILA results include a positive-slack timing path, an LVS summary with zero reported mismatches, and an antenna report that records one violation.

These results demonstrate why a completed flow should not automatically be described as having passed every possible signoff check.

A careful engineering workflow examines the evidence from each stage and distinguishes successful results from outstanding issues.

### 11.4 Maintaining a reviewable project repository

A hardware project is more useful to reviewers when it preserves its RTL, testbenches, logs, configuration, and implementation artifacts in a structured repository.

AQUILA's GitHub repository is organized to make those components accessible without requiring the reviewer to reconstruct the project entirely from screenshots.

---

## 📈 12. Future Improvements

AQUILA provides a foundation for further improvements in both RTL verification and physical implementation.

Potential next steps include:

### RTL and functional verification

* Expand testbench coverage for reset behavior and state transitions.
* Add additional tests for timer boundaries and counter behavior.
* Test more input combinations and unexpected operating sequences.
* Add assertions or formal properties for important controller invariants.
* Create a single script or Makefile to compile and run all testbenches.
* Keep verification logs synchronized with the latest RTL revision.

### Timing and physical implementation

* Review the complete timing reports and evaluate the coverage of timing paths.
* Investigate the recorded antenna violation and implement a suitable correction if required.
* Rerun the relevant physical checks after any implementation changes.
* Record the complete tool versions, platform versions, and configuration used for each run.
* Compare results across different implementation settings when appropriate.

### Documentation and reproducibility

* Document the precise top-level interface and module port descriptions.
* Add an FSM state diagram based directly on the implemented RTL.
* Document the timer parameters and their intended operating conditions.
* Provide a reproducible flow setup guide.
* Record a versioned set of simulation and implementation results.
* Add gate-level simulation as a separate validation activity if required.

These improvements would strengthen the project's reproducibility, verification depth, and usefulness as a portfolio demonstration.

---

## 🎓 13. Engineering Concepts Demonstrated

The project brings together several concepts relevant to digital design and VLSI engineering.

| Area                  | Concepts                                                                         |
| --------------------- | -------------------------------------------------------------------------------- |
| Digital design        | Sequential logic, finite state machines, timer/counter logic, module integration |
| RTL development       | Verilog coding, modular design, source organization                              |
| Verification          | Testbench development, directed simulation, waveform inspection, simulation logs |
| Synthesis             | RTL transformation into a technology-mapped netlist                              |
| Physical design       | Floorplanning, placement, clock-tree synthesis, routing                          |
| Timing analysis       | Timing constraints, path arrival time, required time, slack                      |
| Parasitic analysis    | Extracted interconnect information represented in SPEF                           |
| Physical verification | LVS-related comparison and antenna checking                                      |
| ASIC deliverables     | GDSII layout generation                                                          |
| Engineering workflow  | Configuration management, artifact preservation, technical documentation         |

The project's primary value is the opportunity to study how these stages connect in a single design workflow.

---

## ⚠️ 14. Scope and Technical Limitations

AQUILA should be understood as an academic digital-design and ASIC implementation project.

The repository documents a Verilog controller, RTL simulations, and selected physical-design outputs. It does not establish that a complete mains-powered water-pump system has been built or validated.

A real-world pump-control product would require appropriate sensors, electrical interfaces, power drivers, isolation, protection mechanisms, fault handling, and system-level validation.

Similarly:

* RTL simulation does not establish physical hardware behavior.
* A synthesized netlist does not establish that gate-level simulation has been completed.
* A generated GDSII file does not by itself establish foundry signoff or fabrication.
* Positive slack on one reported path does not prove that every path meets timing.
* The recorded antenna violation must be considered when evaluating the physical-design result.
* The reported LVS result applies to the comparison documented by the included report.

These distinctions are part of responsible engineering documentation and provide a clear basis for future validation.

---

## 🏁 15. Conclusion

**AQUILA — Intelligent Water Pump Controller** demonstrates a modular Verilog-based digital-control design taken through an RTL-to-GDSII implementation workflow.

The project combines a top-level controller with dedicated FSM and timer modules, provides separate testbenches and saved waveforms, and preserves the results of an OpenLane implementation targeting the Sky130A standard-cell platform.

The recorded run produced a synthesized netlist, routed physical-design artifacts, timing and verification reports, and a final GDSII layout database. The repository also retains screenshots that help illustrate the different stages of the workflow.

Beyond the final layout, the project provides practical experience with the relationship between RTL design, simulation, synthesis, physical implementation, and report interpretation.

It also demonstrates the importance of evaluating implementation results carefully: the recorded LVS summary reports zero mismatches, the selected timing report shows positive slack for an inspected path, and the antenna report identifies an outstanding violation.

Together, these artifacts form a documented foundation for further work in RTL design, design verification, digital design, and ASIC implementation.

---

## 👨‍💻 Author

**Ganesh Koushal**
B.Tech — Electronics and Communication Engineering

**Areas of interest:**
RTL Design • Design Verification • Digital Design • VLSI Design • ASIC Implementation

---

### AQUILA — Intelligent Water Pump Controller

*Designed in Verilog HDL. Simulated, synthesized, and taken through an OpenLane RTL-to-GDSII implementation flow targeting Sky130A.*
