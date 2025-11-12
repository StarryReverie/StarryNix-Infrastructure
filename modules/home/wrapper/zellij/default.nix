{ lib, pkgs, ... }:
let
  configDir = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./config.kdl
      ./layouts
    ];
  };
in
{
  wrappers.zellij.basePackage = pkgs.zellij;

  wrappers.zellij.prependFlags = [
    "--config-dir=${configDir}"
  ];
}
