{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
{
  users.users.${constants.username}.maid = {
    packages = with pkgs; [
      wl-clipboard
      cliphist
      (pkgs.writeScriptBin "clipboard-select" (builtins.readFile ./clipboard-select.sh))
    ];
  };
}
