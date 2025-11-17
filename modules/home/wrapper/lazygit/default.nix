{
  config,
  lib,
  pkgs,
  ...
}:
let
  difftasticExecutable = lib.getExe (config.wrappers.difftastic.wrapped or pkgs.difftastic);

  configFile = pkgs.writers.writeYAML "config.yaml" {
    gui = {
      language = "en";
      timeFormat = "2006/01/02";
      showRandomTip = false;
      border = "single";
    };

    git = {
      pagers = lib.singleton {
        externalDiffCommand = "${difftasticExecutable} --color=always";
      };
    };

    update = {
      method = "never";
    };

    disableStartupPopups = true;
  };
in
{
  wrappers.lazygit.basePackage = pkgs.lazygit;

  wrappers.lazygit.prependFlags = [
    "--use-config-file=${configFile}"
  ];

  settings.zsh.shellAliases = {
    lg = "lazygit";
  };
}
