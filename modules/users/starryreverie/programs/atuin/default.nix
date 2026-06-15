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
        rcContent = (
          lib.mkOrder 1150 ''
            # ===== Atuin integration
            # Loaded after zvm (which uses ZVM_INIT_MODE=sourcing) so this
            # ^R binding overwrites zvm's default history-incremental-search-backward.
            eval "$(${lib.getExe pkgs.atuin} init zsh --disable-up-arrow)"
            bindkey -M vicmd '^r' _atuin_search_widget
          ''
        );
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
