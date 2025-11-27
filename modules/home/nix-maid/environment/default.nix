{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              homeSessionVariables = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                description = ''
                  All session environment variables to be set per-user. Values are
                  directly written to the file in `$XDG_CONFIG_HOME/environment.d/`
                  without escaping.
                '';
                default = { };
              };
            };

            config = {
              maid.file.home.".profile".text = ''
                source <(${pkgs.systemd}/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
              '';

              maid.file.xdg_config."environment.d/60-maid-session-vars.conf".text =
                let
                  vars = config.users.users.${name}.homeSessionVariables;
                  varEntries = lib.attrsets.mapAttrsToList (k: v: "${k}=${v}") vars;
                  varFileContent = builtins.concatStringsSep "\n" varEntries;
                in
                varFileContent;
            };
          }
        )
      );
    };
  };
}
