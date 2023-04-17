{
  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      devShell.${system} = with nixpkgs.legacyPackages.${system}; mkShell {
        buildInputs = [
          (ghdl.overrideAttrs (oldAttrs: {
            version = "3.0.0";
            src = fetchFromGitHub {
              owner = "ghdl";
              repo = "ghdl";
              rev = "v3.0.0";
              hash = "sha256-94RNtHbOpbC2q/Z+PsQplrLxXmpS3LXOCXyTBB+n9c4=";
            };
            patches = [];
          }))
        ];
      };
    };
}
