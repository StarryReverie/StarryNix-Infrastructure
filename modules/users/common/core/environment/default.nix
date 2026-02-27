{
  config,
  lib,
  pkgs,
  ...
}:
let
  customEnvironmentSubmodule =
    { name, ... }:
    let
      selfCfg = config.custom.users.${name};
      customCfg = selfCfg.core.environment;
    in
    {
      options.core.environment = {
        sessionVariables = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = ''
            All session environment variables to be set per-user. Values are directly written to the
            file in `$XDG_CONFIG_HOME/environment.d/` without escaping.
          '';
          default = { };
          example = {
            EDITOR = "hx";
          };
        };

        graphicalSessionVariables = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = ''
            All graphical session environment variables to be set per-user. Values are directly
            written to the file in `$XDG_CONFIG_HOME/environment.d/` without escaping.
          '';
          default = { };
          example = {
            LANG = "zh_CN.UTF-8";
          };
        };
      };
    };

  customEnvironmentEffectSubmodule =
    { name, ... }:
    let
      selfCfg = config.custom.users.${name} or { };
      customCfg = selfCfg.core.environment or { };
    in
    {
      config = lib.mkIf (customCfg.enable or false) {
        maid = {
          file.home.".profile".text =
            if customCfg.graphicalSessionVariables == { } then
              ''
                source <(${pkgs.systemd}/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
              ''
            else
              ''
                if [[ "''${XDG_SESSION_TYPE:-tty}" == "tty" ]]; then
                  source <(${pkgs.systemd}/lib/systemd/user-environment-generators/30-systemd-environment-d-generator | grep -v ${
                    lib.pipe customCfg.graphicalSessionVariables [
                      lib.attrsets.attrNames
                      (lib.lists.map (name: "-e '^${name}='"))
                      (lib.strings.concatStringsSep " ")
                    ]
                  })
                else
                  source <(${pkgs.systemd}/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
                fi
              '';

          file.xdg_config."environment.d/60-custom-session-vars.conf".text =
            lib.pipe customCfg.sessionVariables
              [
                (lib.attrsets.mapAttrsToList (k: v: "${k}=${v}"))
                (lib.strings.concatStringsSep "\n")
              ];

          file.xdg_config."environment.d/60-custom-graphical-session-vars.conf".text =
            lib.pipe customCfg.graphicalSessionVariables
              [
                (lib.attrsets.mapAttrsToList (k: v: "${k}=${v}"))
                (lib.strings.concatStringsSep "\n")
              ];
        };
      };
    };
in
{
  options.custom.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customEnvironmentSubmodule);
  };

  options.users.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customEnvironmentEffectSubmodule);
  };
}
