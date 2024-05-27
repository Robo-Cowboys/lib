{
  perSystem = _: {
    just-flake.features.test = {
      enable = true;
      justfile = ''
        # Rebuild the system using `nh os test`
        test:
          nix flake update robo-nix-lib
          nh os test
      '';
    };
  };
}
