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
      selfCfg = config.users.users.${name};
      customCfg = selfCfg.custom.core.environment;
    in
    {
      options.custom.core.environment = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to enable environment-related settings";
          default = false;
          example = true;
        };

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

      config = {
        maid = lib.mkIf customCfg.enable {
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
  options.users.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customEnvironmentSubmodule);
  };
}
