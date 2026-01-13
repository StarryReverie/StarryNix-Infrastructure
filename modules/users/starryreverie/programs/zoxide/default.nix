{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie = {
    maid = {
      packages = with pkgs; [ zoxide ];
    };

    custom.zsh = {
      rcContent = ''
        # ===== Zoxide integration
        eval "$(${lib.getExe pkgs.zoxide} init zsh --cmd cd)"
      '';
    };
  };

  preservation.preserveAt."/nix/persistence" = {
    users.starryreverie = {
      directories = [ ".local/share/zoxide" ];
    };
  };
}
