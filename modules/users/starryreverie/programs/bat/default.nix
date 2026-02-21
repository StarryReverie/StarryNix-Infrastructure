{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.programs.bat or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [ bat ];

      file.xdg_config."bat/config".text = ''
        --style="-changes,-numbers,-snip"
        --theme="OneHalfDark"
      '';
    };
  };
}
