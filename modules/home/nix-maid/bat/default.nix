{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
{
  users.users.${constants.username}.maid = {
    packages = with pkgs; [ bat ];

    file.xdg_config."bat/config".text = ''
      --style="-changes,-numbers,-snip"
      --theme="OneHalfDark"
    '';
  };
}
