{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports =
    let
      searchedModuleRoots = [
        ./system
        ./users
      ];
      excludedModuleRoots = [
        ./system/starrynix-infrastructure
      ];
    in
    lib.pipe searchedModuleRoots [
      (lib.lists.map lib.filesystem.listFilesRecursive)
      lib.lists.flatten
      (lib.lists.map builtins.toString)
      (lib.lists.filter (lib.strings.hasSuffix ".nix"))
      (lib.lists.filter (
        p:
        lib.lists.all (excluded: !(lib.strings.hasPrefix excluded p)) (
          lib.lists.map builtins.toString excludedModuleRoots
        )
      ))
    ];
}
