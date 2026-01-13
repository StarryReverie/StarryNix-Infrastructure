{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie.maid = {
    packages = with pkgs; [ bat ];

    file.xdg_config."bat/config".text = ''
      --style="-changes,-numbers,-snip"
      --theme="OneHalfDark"
    '';
  };
}
