# 1. Clear existing waves (optional, remove if you want to keep them)
# restart

# 2. Add all signals from the testbench top level
add_wave /sap1_top_tb/*

# 3. Add all signals from the Top Module (including buses)
add_wave /sap1_top_tb/uut/*

# 4. Add key internal signals from sub-modules
add_wave -group "CONTROLLER" /sap1_top_tb/uut/u_controller/*
add_wave -group "ALU_INTERNAL" /sap1_top_tb/uut/u_alu/*
add_wave -group "DIVIDER_INTERNAL" /sap1_top_tb/uut/u_alu/u_divider/*
add_wave -group "REGISTERS" {/sap1_top_tb/uut/u_acc/* /sap1_top_tb/uut/u_b_reg/* /sap1_top_tb/uut/u_pc/* /sap1_top_tb/uut/u_ir/*}

# 5. Configure display format
wave config -table_width 100
wave config -value_width 100

# 6. Run the simulation
run all
