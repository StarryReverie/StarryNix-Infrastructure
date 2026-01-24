{
  config,
  lib,
  pkgs,
  ...
}:
let
  configFile = pkgs.writers.writeTOML "direnv.toml" {
    global = {
      log_filter = "^$";
      log_format = "-";
    };
  };
in
{
  users.users.starryreverie = {
    maid = {
      packages = [ pkgs.direnv ];

      file.xdg_config."direnv/direnv.toml".source = configFile;
      file.xdg_config."direnv/direnvrc".source = ./direnv-stdlib.sh;
      file.xdg_config."direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
    };

    custom.applications.zsh = {
      rcContent = ''
        # ===== Direnv integration
        eval "$(${lib.getExe pkgs.direnv} hook zsh)"
      '';
    };
  };

  preservation.preserveAt."/nix/persistence" = {
    users.starryreverie = {
      directories = [ ".local/share/direnv" ];
    };
  };
}
