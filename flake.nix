{
  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      devShell.${system} = with nixpkgs.legacyPackages.${system}; mkShell {
        buildInputs =
          let
            ghdl-nightly = (ghdl.overrideAttrs (oldAttrs: {
              version = "3.0.0";
              src = fetchFromGitHub {
                owner = "ghdl";
                repo = "ghdl";
                rev = "v3.0.0";
                hash = "sha256-94RNtHbOpbC2q/Z+PsQplrLxXmpS3LXOCXyTBB+n9c4=";
              };
              patches = [];
            }));
          in
          [
            gtkwave
            ghdl-nightly
            (
              python3.withPackages (ps: with ps;
              let
                vunit_hdl = buildPythonPackage rec {
                  pname = "vunit_hdl";
                  version = "4.7.0";
                  format = "setuptools";

                  src = fetchPypi {
                    inherit pname version;
                    hash = "sha256-ol+5kbq9LqhRlm4NvcX02PZJqz5lDjASmDsp/V0Y8i0=";
                  };

                  propagatedBuildInputs = [ colorama ];
                  nativeBuildInputs = [ ghdl-nightly ];

                  doCheck = false;
                };
              in
              [
                vunit_hdl
              ])
            )
          ];
      };
    };
}