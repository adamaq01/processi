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
lib.add_source_file("src/file_register.vhd")
lib.add_source_file("src/alu.vhd")

# Add all tests files ending in .vhd to library
lib.add_source_files("tests/*.vhd")

# Run vunit function
vu.main()
