set top "top"
set board "basys3"
set build_dir "build"
set part "xc7a35tcpg236-1"

proc read_files {} {
    # Compile any .sv, .v, and .vhd files that exist in the current directory
    if {[glob -nocomplain src/*.sv] != ""} {
        puts "Reading SV files..."
        read_verilog -sv [glob src/*.sv]
    }
    if {[glob -nocomplain src/*.v] != ""} {
        puts "Reading Verilog files..."
        read_verilog [glob src/*.v]
    }
    if {[glob -nocomplain src/*.vhd] != ""} {
        puts "Reading VHDL files..."
        read_vhdl [glob src/*.vhd]
    }
}

proc add_files_to_proj {} {
    set file_list {}
    foreach dir {src tb} {
        foreach ext {sv v vhd} {
            set files [glob -nocomplain $dir/*.$ext]
            if {$files != ""} {
                lappend file_list {*}$files
            }
        }
    }
    if {[llength $file_list] > 0} {
        puts "Adding files to project..."
        add_files -fileset sources_1 $file_list

        # Set properties for each file type only if files exist
        if {[llength [get_files *.vhd]] > 0} {
            set_property file_type {VHDL} [get_files *.vhd]
        }
        if {[llength [get_files *.v]] > 0} {
            set_property file_type {Verilog} [get_files *.v]
        }
        if {[llength [get_files *.sv]] > 0} {
            set_property file_type {SystemVerilog} [get_files *.sv]
        }
    }
}

proc synthesize {} {
    global top
    global part

    puts "Synthesizing design..."
    synth_design -top $top -part $part -flatten_hierarchy full
}

proc synth_rtl {top} {
    global part

    read_files

    puts "Synthesizing design..."
    synth_design -rtl -name rtl_1 -top $top -part $part
}

proc compile {} {
    global top
    global board
    global build_dir
    global part

    puts "Closing any designs that are currently open..."
    puts ""
    close_project -quiet
    puts "Continuing..."

    read_xdc constr/$board.xdc

    read_files
    synthesize

    puts "Optimizing design..."
    opt_design

    puts "Placing Design..."
    place_design

    # Hack to move the clockInfo.txt into the build artifacts directory 
    file rename -force "clockInfo.txt" "$build_dir/clockInfo.txt"

    puts "Routing Design..."
    route_design

    puts "Writing checkpoint"
    write_checkpoint -force $build_dir/$top.dcp

    puts "Writing bitstream"
    write_bitstream -force $build_dir/$top.bit

    puts "All done..."
}

proc simulate {top sim_time} {
    global part
    global build_dir
    set top_tb "${top}_tb"

    puts "Closing any designs that are currently open..."
    puts ""
    close_sim -force -quiet
    close_project -quiet
    puts "Continuing..."

    create_project -force -part $part $top_tb $build_dir

    add_files_to_proj

    update_compile_order -fileset sources_1
    set_property top $top_tb [get_fileset sim_1]
    set_property -name {xsim.simulate.runtime} -value $sim_time -objects [get_filesets sim_1]

    launch_simulation
}

proc program_hw {} {
    global top
    global build_dir

    puts "Restarting HW manager..."
    close_hw_manager

    puts "Connecting to HW server..."
    open_hw_manager
    connect_hw_server
    open_hw_target

    puts "Programming the device..."

    puts "Getting the current Device"
    set hw_devices [get_hw_devices]
    set hw_devices_length [llength $hw_devices]
    set current_device [lindex $hw_devices 0]

    current_hw_device [get_hw_devices $current_device]

    set_property PROBES.FILE {} [get_hw_devices $current_device]
    set_property FULL_PROBES.FILE [] [get_hw_devices $current_device]
    set_property PROGRAM.FILE $build_dir/$top.bit [get_hw_devices $current_device]

    #refresh_hw_device -update_hw_probes false [lindex [get_hw_devices $current_device] 0]
    program_hw_devices [get_hw_devices $current_device]
    refresh_hw_device [lindex [get_hw_devices $current_device] 0]
}

proc compile_and_program {} {
    compile
    program_hw
}
