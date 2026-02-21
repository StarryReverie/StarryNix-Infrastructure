{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.programs.direnv or { };
in
let
  configFile = pkgs.writers.writeTOML "direnv.toml" {
    global = {
      log_filter = "^$";
      log_format = "-";
    };
  };
in
{
  config = {
    custom.users.starryreverie = {
      applications.zsh = lib.mkIf (customCfg.enable or false) {
        rcContent = ''
          # ===== Direnv integration
          eval "$(${lib.getExe pkgs.direnv} hook zsh)"
        '';
      };
    };

    users.users.starryreverie.maid = lib.mkIf (customCfg.enable or false) {
      packages = [ pkgs.direnv ];

      file.xdg_config."direnv/direnv.toml".source = configFile;
      file.xdg_config."direnv/direnvrc".source = ./direnv-stdlib.sh;
      file.xdg_config."direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
    };

    preservation.preserveAt."/nix/persistence" = lib.mkIf (customCfg.enable or false) {
      users.starryreverie = {
        directories = [ ".local/share/direnv" ];
      };
    };
  };
}
