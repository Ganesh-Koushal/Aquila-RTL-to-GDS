# Physical-Design Reports — AQUILA

This directory contains selected reports from the recorded OpenLane implementation run.

## 1. Included reports

### `24-opensta_spef.min_max.rpt` — OpenSTA timing

This report contains a path analyzed using extracted parasitic information. The inspected path reports:
- Data arrival time: 8.09 ns.
- Required time: 19.85 ns.
- Slack: +11.76 ns.

The positive slack applies to the path shown in the report under its constraints. It must not be generalized into a claim that every path meets timing or that all signoff requirements have passed.

### `41-antenna.rpt` — Antenna check

This report records an antenna violation. The result should be disclosed accurately; the design should not be called antenna-clean based on this run. Investigate the reported net/pin and rerun the relevant check after any corrective change.

### `water_pump_controller.lvs_parsed.lef.log` — Parsed LVS summary

The parsed summary reports no net, device, pin, or property mismatches and reports zero total errors. The underlying log should be consulted for full context if the design or flow is changed.

## 2. Correct use of reports

A report is evidence for the checks and design state it actually covers. When documenting results:
1. Name the report and implementation run.
2. Quote the result with its units and context.
3. Distinguish path-specific timing from full-design timing closure.
4. Disclose recorded violations rather than omitting them.
5. Rerun checks after changes to RTL, constraints, libraries, or physical implementation.

See [`../README.md`](../README.md) for the artifact inventory and run-level summary.
