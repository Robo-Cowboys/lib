{
  perSystem = _: {
    just-flake.features.build = {
      enable = true;
      justfile = ''
        # given a `target` build that systems image.
        build target:
          set -euo pipefail
          nix flake update robo-nix-lib
          nix build .#nixosConfigurations.{{target}}.config.system.build.toplevel
      '';
    };
  };
}
