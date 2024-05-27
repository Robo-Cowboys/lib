{
  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    just-flake.features.iso = {
      enable = true;
      justfile = ''
        # given a `target` build that systems iso and flash it to USB.
        iso target:
          set -euo pipefail
          nix flake update robo-nix-lib
          nix build .#nixosConfigurations.{{target}}.config.system.build.toplevel
          ${lib.getExe pkgs.caligula} burn ./result/{{target}}.iso
      '';
    };
  };
}
