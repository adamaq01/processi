#!/usr/bin/env python

from vunit import VUnit

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv(compile_builtins=False)

# Optionally add VUnit's builtin HDL utilities for checking, logging, communication...
# See http://vunit.github.io/hdl_libraries.html.
vu.add_vhdl_builtins()

# Create library 'lib' with standard VHDL 2002
lib = vu.add_library("lib")

# Add all source files ending in .vhd to library
lib.add_source_file("src/components/file_register.vhd")
lib.add_source_file("src/components/alu.vhd")
lib.add_source_file("src/components/mux_21.vhd")
lib.add_source_file("src/components/sign_extender.vhd")
lib.add_source_file("src/components/data_memory.vhd")
lib.add_source_file("src/components/instruction_memory.vhd")
lib.add_source_file("src/components/register32.vhd")
lib.add_source_file("src/components/instruction_decoder.vhd")
lib.add_source_file("src/components/state_register.vhd")
lib.add_source_file("src/operation_unit.vhd")
lib.add_source_file("src/processing_unit.vhd")
lib.add_source_file("src/control_unit.vhd")
lib.add_source_file("src/cpu.vhd")
lib.add_source_file("src/components/seven_seg_decoder.vhd")
lib.add_source_file("src/top_level.vhd")

# Add all tests files ending in .vhd to library
lib.add_source_files("simu/*.vhd")

# Run vunit function
vu.main()
