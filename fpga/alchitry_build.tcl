# Create project
create_project -force test_project ./build -part xc7a35tftg256-1 

# Add source files
add_files {src/au_top.v src/reset_conditioner.v}
add_files -fileset constrs_1 src/au.xdc

# Set the top module and settings
set_property top au_top [current_fileset]
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]

# Build bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_runs impl_1

# Copy the bin file from the build folder 
file copy -force build/test_project.runs/impl_1/au_top.bin .