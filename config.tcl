# Water Pump Controller - OpenLane v0.21

set ::env(DESIGN_NAME) "water_pump_controller"

set ::env(VERILOG_FILES) [list \
    $::env(OPENLANE_ROOT)/designs/water_pump_controller/src/water_pump_controller.v \
    $::env(OPENLANE_ROOT)/designs/water_pump_controller/src/pump_fsm.v \
    $::env(OPENLANE_ROOT)/designs/water_pump_controller/src/flow_timer.v \
    $::env(OPENLANE_ROOT)/designs/water_pump_controller/src/restart_timer.v \
]

set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_PERIOD) "20"

set ::env(CLOCK_NET) "clk"
set ::env(SDC_FILE) "$::env(OPENLANE_ROOT)/designs/water_pump_controller/src/water_pump_controller.sdc"

set filename $::env(OPENLANE_ROOT)/designs/$::env(DESIGN_NAME)/$::env(PDK)_config.tcl
if {[file exists $filename]} {
    source $filename
}
