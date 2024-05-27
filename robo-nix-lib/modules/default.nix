{self, ...}: let
  mkFlakeModule = path:
    if builtins.isPath path
    then self + path
    else builtins.throw "${path} is not a real path! Are you stupid?";
in {
  flake = {
    # set of modules exposed by my flake to be consumed by others
    # those can be imported by adding this flake as an input and then importing the nixosModules.<moduleName>
    # i.e imports = [ inputs.robo-nyx.nixosModules.steam-compat ]; or modules = [ inputs.robo-nyx.nixosModules.steam-compat ];
    nixosModules = {
      # we do not want to provide a default module
      default = builtins.throw "There is no default module, sorry!";
    };

    homeManagerModules = {
      # now available in home-manager
      # xplr = mkModule /modules/extra/shared/home-manager/xplr;

      # a home-baked module for gtklock
      # allows definning extra modules and the stylesheet
      # FIXME: gtklock is currently broken thanks to the deprecation of the necessary wayland protocol
      gtklock = mkFlakeModule /modules/extra/shared/home-manager/gtklock;

      vifm = mkFlakeModule /modules/extra/shared/home-manager/vifm;

      # again, we do not want to provide a default module
      default = builtins.throw "There is no default module, sorry!";
    };
  };
}
