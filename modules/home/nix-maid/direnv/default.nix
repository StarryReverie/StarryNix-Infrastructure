{
  config,
  lib,
  pkgs,
  constants,
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
  users.users.${constants.username} = {
    maid = {
      packages = [ pkgs.direnv ];

      file.xdg_config."direnv/direnv.toml".source = configFile;
      file.xdg_config."direnv/direnvrc".source = ./direnv-stdlib.sh;
      file.xdg_config."direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
    };

    custom.zsh = {
      rcContent = ''
        # ===== Direnv integration
        eval "$(${lib.getExe pkgs.direnv} hook zsh)"
      '';
    };
  };
}
