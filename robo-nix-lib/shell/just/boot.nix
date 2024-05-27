{
  perSystem = _: {
    just-flake.features.boot = {
      enable = true;
      justfile = ''
        # Rebuild the system using `nh os boot`
        boot:
          nix flake update robo-nyx
          nh os boot
      '';
    };
  };
}
