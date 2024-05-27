{
  inputs,
  src,
  ...
}: {
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.pre-commit-hooks-nix.flakeModule

    inputs.just-flake.flakeModule
    ./just/switch.nix
    ./just/boot.nix
    ./just/iso.nix
    ./just/build.nix
    ./just/test.nix
    ./just/tree-fmt.nix #tree fmt command
  ];

  perSystem = {
    pkgs,
    config,
    ...
  }: {
    # Add your auto-formatters here.
    # cf. https://numtide.github.io/treefmt/
    treefmt.config = {
      projectRootFile = src + "/flake.nix";
      flakeCheck = false; # pre-commit-hooks.nix checks this
      #robo-nix-lib
      programs = {
        alejandra.enable = true;
        black.enable = true;
        deadnix.enable = true;
        statix = {
          enable = true;
          disabled-lints = [
            "manual_inherit_from"
          ];
        };
        mdformat.enable = true;
        taplo.enable = true;
        shfmt.enable = true;
        prettier.enable = true;
      };
    };

    devShells.default = pkgs.mkShell {
      inputsFrom = [
        config.treefmt.build.devShell
        config.just-flake.outputs.devShell
        config.pre-commit.devShell
      ];
      packages = [
        pkgs.caligula
      ];
    };
  };
}
