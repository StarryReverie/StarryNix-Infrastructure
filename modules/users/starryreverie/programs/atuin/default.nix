{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.programs.atuin or { };
in
{
  config = {
    custom.users.starryreverie = {
      applications.zsh = lib.mkIf (customCfg.enable or false) {
        rcContent = ''
          # ===== Atuin integration
          eval "$(${lib.getExe pkgs.atuin} init zsh)"
        '';
      };
    };

    users.users.starryreverie.maid = lib.mkIf (customCfg.enable or false) {
      packages = with pkgs; [ atuin ];

      file.xdg_config."atuin/config.toml".source = ./config.toml;
    };

    preservation.preserveAt."/nix/persistence" = lib.mkIf (customCfg.enable or false) {
      users.starryreverie = {
        directories = [ ".local/share/atuin" ];
      };
    };
  };
}
