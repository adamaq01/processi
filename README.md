# ARM7TDMI VHDL CPU

This project is a VHDL implementation of a simplified ARM7TDMI CPU.

## Dependencies

You need to have a VHDL simulator installed on your system, whether it is GHDL or ModelSim.

You also need to have Python 3 installed on your system with vunit_hdl installed to run the testbenches.

You can install vunit_hdl using pip:

```bash
pip install vunit_hdl
```

## Nix

For linux users, a nix flake with the necessary dependencies is provided (ghdl, gtkwave, python, vunit).

You can use it to run the testbenches or to build the project.

Just run the following command to enter a shell with the dependencies:

```bash
nix develop
```

## Testbenches

You can run every testbenches using the following command:

```bash
./run_tests.py
```

If you want to be more specific, you can look at the help:

```bash
./run_tests.py --help
```

## Authors

* Adam Thibert (adam.thibert)
* Adrien Navratil (adrien.navratil)
