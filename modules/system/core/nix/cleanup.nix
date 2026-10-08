{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.core.nix;
in
{
  config = lib.mkIf customCfg.enable {
    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    nix.optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
}
