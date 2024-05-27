{
  perSystem = _: {
    just-flake.features.boot = {
      enable = true;
      justfile = ''
        # Rebuild the system using `nh os boot`
        boot:
          nix flake update robo-nix-lib
          nh os boot
      '';
    };
  };
}
