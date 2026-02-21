{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.mpv or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [
        (mpv.override {
          scripts = with pkgs.mpvScripts; [
            mpris
            uosc
          ];
        })
      ];

      file.xdg_config."mpv/mpv.conf".source = ./mpv.conf;
      file.xdg_config."mpv/input.conf".source = ./input.conf;
    };
  };
}
