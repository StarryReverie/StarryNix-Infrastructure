{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
{
  users.users.${constants.username} = {
    maid = {
      packages = with pkgs; [ zellij ];

      file.xdg_config."zellij/config.kdl".source = ./config.kdl;
      file.xdg_config."zellij/layouts".source = ./layouts;
    };

    custom.zsh = {
      shellAliases = {
        zj = "zellij";
        zd = "zellij --layout development";
      };

      rcContent = ''
        # Zellij helpers
        ## Attach to a session selected using fzf
        function za() {
            zellij delete-all-sessions --yes 2>&1 > /dev/null
            selected=$(zellij list-sessions | awk --field-separator ' ' '{ print $1 }' | sort | fzf --select-1 --height=~10)
            [ -n "$selected" ] && zellij attach "$selected"
        }
      '';
    };
  };

}
