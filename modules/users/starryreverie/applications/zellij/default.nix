{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.zellij or { };
in
{
  config = {
    custom.users.starryreverie = {
      applications.zsh = lib.mkIf (customCfg.enable or false) {
        shellAliases = {
          zj = "zellij";
          zd = "zellij --layout development";
        };

        rcContent = ''
          # ===== Zellij helpers
          # Attach to a session selected using fzf
          function za() {
              zellij delete-all-sessions --yes 2>&1 > /dev/null
              selected=$(zellij list-sessions | awk --field-separator ' ' '{ print $1 }' | sort | fzf --select-1 --height=~10)
              [ -n "$selected" ] && zellij attach "$selected"
          }
        '';
      };
    };

    users.users.starryreverie.maid = lib.mkIf (customCfg.enable or false) {
      packages = with pkgs; [ zellij ];

      file.xdg_config."zellij/config.kdl".source = ./config.kdl;
      file.xdg_config."zellij/layouts".source = ./layouts;
    };
  };
}
