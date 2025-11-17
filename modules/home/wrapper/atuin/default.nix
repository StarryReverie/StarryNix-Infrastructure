{
  config,
  lib,
  pkgs,
  ...
}:
let
  atuinExecutable = lib.getExe (config.wrappers.atuin.wrapped or pkgs.atuin);

  configFile = pkgs.writers.writeTOML "atuin-config.toml" {
    update_check = false;
    style = "compact";
    show_help = false;
    enter_accept = true;
    workspaces = true;
    inline_height = 15;

    common_subcommands = [
      "nix"
      "cargo"
      "git"
      "./gradlew"
      "./mvnw"
      "systemctl"
      "sudo"
    ];

    common_prefix = [
      "sudo"
    ];

    history_filter = [
      ''^\\.*''
      ''^git reset.*''
      ''^rm.*''
      ''^sudo rm.*''
      ''^ .*''
    ];
  };

  configDir = pkgs.runCommand "atuin-config-dir" { } ''
    mkdir -p $out
    ln -s ${configFile} $out/config.toml
  '';
in
{
  wrappers.atuin.basePackage = pkgs.atuin;

  wrappers.atuin.env = {
    ATUIN_CONFIG_DIR.value = configDir;
  };

  settings.zsh.initContent = ''
    # Atuin integration
    eval "$(${atuinExecutable} init zsh)"
  '';
}
