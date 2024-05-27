{
  inputs,
  src,
  ...
}: {
  perSystem = {
    lib,
    system,
    pkgs,
    ...
  }: rec {
    packages = let
      scope = lib.makeScope pkgs.newScope (self: {inherit inputs;});
    in
      lib.filesystem.packagesFromDirectoryRecursive {
        inherit (scope) callPackage;
        directory = "${src}/packages";
      };
  };
}
