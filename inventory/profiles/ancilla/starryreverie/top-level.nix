{
  inputs,
  pkgs,
  flakeRoot,
  ...
}:
let
  helix-wrapped = inputs.wrapper-manager.lib.wrapWith pkgs {
    basePackage = pkgs.helix-unwrapped;

    prependFlags = [
      "--config"
      "${flakeRoot + /modules/users/starryreverie/applications/helix/config.toml}"
    ];

    env.HELIX_RUNTIME = builtins.toString (
      pkgs.symlinkJoin {
        name = "helix-runtime-extra";

        paths = [
          pkgs.helix.runtime
          (pkgs.runCommand "helix-themes-extra" { } ''
            mkdir -p $out
            cp -r ${flakeRoot + /modules/users/starryreverie/applications/helix/themes} $out/themes
          '')
        ];

      }
    );
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
