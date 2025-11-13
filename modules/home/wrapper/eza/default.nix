{
  config,
  lib,
  pkgs,
  ...
}:
{
  wrappers.eza.basePackage = pkgs.eza;

  wrappers.eza.prependFlags = [
    "--icons=never"
    "--no-git"
    "--group-directories-first"
    "--binary"
    "--group"
    "--time-style=long-iso"
  ];

  wrappers.eza.env = {
    EZA_CONFIG_DIR.value = lib.fileset.toSource {
      root = ./.;
      fileset = ./theme.yml;
    };
  };

  settings.zsh.shellAliases = {
    ls = "eza";
    la = "eza --all --all";
    ll = "eza --long";
    lla = "eza --long --all --all";
    tree = "eza --tree";
  };
}
