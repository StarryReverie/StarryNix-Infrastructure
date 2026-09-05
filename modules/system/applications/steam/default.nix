{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.applications.steam;
in
{
  config = lib.mkIf customCfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };
  };
}
