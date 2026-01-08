{
  config,
  lib,
  pkgs,
  ...
}:
let
  customXdgSubmodule =
    { name, ... }:
    {
      options.custom.xdg = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to enable XDG settings";
          default = false;
          example = true;
        };
      };
    };
in
{
  imports = [
    ./mime-applications.nix
    ./user-directories.nix
  ];

  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule customXdgSubmodule);
    };
  };
}
