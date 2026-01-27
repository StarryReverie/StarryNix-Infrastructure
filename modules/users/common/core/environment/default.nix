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
            All session environment variables to be set per-user. Values are
            directly written to the file in `$XDG_CONFIG_HOME/environment.d/`
            without escaping.
          '';
          default = { };
          example = {
            EDITOR = "hx";
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
          file.home.".profile".text = ''
            source <(${pkgs.systemd}/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
          '';

          file.xdg_config."environment.d/60-custom-session-vars.conf".text =
            let
              vars = customCfg.sessionVariables;
              varEntries = lib.attrsets.mapAttrsToList (k: v: "${k}=${v}") vars;
              varFileContent = builtins.concatStringsSep "\n" varEntries;
            in
            varFileContent;
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
