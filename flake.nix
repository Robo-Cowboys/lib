{
  description = "Robonyx Lib";

  inputs = {
    # global, so they can be `.follow`ed
    systems.url = "github:nix-systems/default-linux";

    # We build against nixos unstable, because stable takes way too long to get things into
    # more versions with or without pinned branches can be added if deemed necessary
    # stable? never heard of her
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NOTE: `nix flake lock --update-input flake-utils-plus` is currently NOT
    # giving us the appropriate revision. We need a fix from a recent PR in
    # FUP, so this revision is being hard coded here for now.
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus?rev=3542fe9126dc492e53ddd252bb0260fe035f2c0f";

    # A tree-wide formatter
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Powered by
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs: let
    core-inputs =
      inputs
      // {
        src = ./.;
      };

    # A wrapper to create our main libraries and then send them thru flake-parts.lib.mkFlake.
    # Usage: mkRoboFlake { inherit inputs; src = ./.; ... }
    mkRoboFlake = flake-and-lib-options @ {
      inputs,
      src,
      ...
    }:
      inputs.flake-parts.lib.mkFlake {inherit inputs;} ({withSystem, ...}: {
        # systems for which the attributes of `perSystem` will be built
        # and more if they can be supported...
        #  - x86_64-linux: Desktops, laptops, servers
        #  - aarch64-linux: ARM-based devices, PoC server and builders
        systems = import inputs.systems;

        # import parts of the flake, which allows me to build the final flake
        # from various parts constructed in a way that makes sense to me
        # the most
        imports = [
          # this is used to be able to refrence the root src directory of the filesystem.
          {_module.args.src = src;}

          # parts and modules from inputs
          inputs.flake-parts.flakeModules.easyOverlay
          inputs.treefmt-nix.flakeModule

          # parts of the flake
          ./robo-nix-lib/lib # extended library on top of `nixpkgs.lib`
          ./robo-nix-lib/pre-commit # pre-commit hooks, performed before each commit inside the devShell

          ./robo-nix-lib/args # args that are passed to the flake.
          ./robo-nix-lib/packages # packages that are loaded recursivly based on the packages directory.
          ./robo-nix-lib/iso-images # local installation media
          ./robo-nix-lib/shell # devShells exposed by the flake
        ];

        flake = {
          # entry-point for NixOS configurations
          nixosConfigurations = import "${src}/hosts" {inherit inputs withSystem;};
        };
      });
  in {
    inherit mkRoboFlake;

    formatter = {
      x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.alejandra;
      aarch64-linux = inputs.nixpkgs.legacyPackages.aarch64-linux.alejandra;
      x86_64-darwin = inputs.nixpkgs.legacyPackages.x86_64-darwin.alejandra;
      aarch64-darwin = inputs.nixpkgs.legacyPackages.aarch64-darwin.alejandra;
    };
  };
}
