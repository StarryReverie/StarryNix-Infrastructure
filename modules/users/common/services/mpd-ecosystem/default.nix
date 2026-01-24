{
  config,
  lib,
  pkgs,
  ...
}:
let
  customMpdEcosystemSubmodule =
    { name, ... }:
    {
      options.custom.services.mpd-ecosystem = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = ''
            Whether to enable MPD ecosystem components. This by default enables
            and configures the daemon
          '';
          default = false;
          example = true;
        };
      };
    };
in
{
  imports = [
    ./client.nix
    ./daemon.nix
  ];

  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule customMpdEcosystemSubmodule);
    };
  };
}
