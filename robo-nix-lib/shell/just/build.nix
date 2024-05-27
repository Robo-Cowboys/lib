{
  perSystem = _: {
    just-flake.features.build = {
      enable = true;
      justfile = ''
        # given a `target` build that systems image.
        build target:
          set -euo pipefail
          nix flake update robo-nyx
          nix build .#nixosConfigurations.{{target}}.config.system.build.toplevel
      '';
    };
  };
}
