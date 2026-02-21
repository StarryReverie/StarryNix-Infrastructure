{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.programs.zoxide or { };
in
{
  config = {
    custom.users.starryreverie = {
      applications.zsh = lib.mkIf (customCfg.enable or false) {
        rcContent = ''
          # ===== Zoxide integration
          eval "$(${lib.getExe pkgs.zoxide} init zsh --cmd cd)"
        '';
      };
    };

    users.users.starryreverie.maid = lib.mkIf (customCfg.enable or false) {
      packages = with pkgs; [ zoxide ];
    };

    preservation.preserveAt."/nix/persistence" = lib.mkIf (customCfg.enable or false) {
      users.starryreverie = {
        directories = [ ".local/share/zoxide" ];
      };
    };
  };
}
