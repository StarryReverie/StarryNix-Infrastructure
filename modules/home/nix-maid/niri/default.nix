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
      kanshi
    ];

    file.xdg_config."niri/config.kdl".text = lib.mkAfter (builtins.readFile ./config.kdl);
  };
}
