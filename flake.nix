{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem = { pkgs, lib, ... }:
      let
        lbforth = pkgs.stdenv.mkDerivation {
          name = "lbforth";
          src = lib.cleanSource ./.;

          buildPhase = ''
            $CC $src/lbForth.c
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp a.out $out/bin/lbforth
          '';
        };
      in
      {
        packages = {
          inherit lbforth;
          default = lbforth;
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nil
          ];
        };
      };
    };
}
