{
  inputs,
  pkgs,
  flakeRoot,
  ...
}:
let
  helix-wrapped = inputs.wrapper-manager.lib.wrapWith pkgs {
    basePackage = pkgs.steelix.unwrapped;

    prependFlags = [
      "--config"
      "${flakeRoot + /modules/users/starryreverie/applications/helix/config.toml}"
    ];
  };
in
{
  paths = [
    helix-wrapped
    pkgs.difftastic
    pkgs.direnv
    pkgs.htop
    pkgs.lazygit
    pkgs.nixfmt
    pkgs.nixfmt-tree
    pkgs.yazi-unwrapped
    pkgs.zellij
  ];
}
