{
  config,
  lib,
  pkgs,
  options,
  ...
}:
let
  customSubmodule =
    { name, ... }:
    {
      # Mirrors the structure of system-scoped `custom.system.<domain>.<feature>`.
      options = lib.attrsets.mapAttrs (
        domain: perDomain:
        lib.attrsets.mapAttrs (feature: perFeature: {
          enable = lib.mkOption {
            type = lib.types.bool;
            description = ''
              Whether to enable user-scoped feature option `custom.users.<user>.${domain}.${feature}`
            '';
            default = false;
            example = true;
          };
        }) perDomain
      ) options.custom.system;
    };

  customEffectSubmodule =
    { name, ... }:
    {
      config = lib.mkIf (lib.attrsets.hasAttr name config.custom.users) (
        lib.mkOverride 950 {
          # Users can be created unexpectedly due to the presence of some configuration definitions
          # inside `users.users.<name>`, even though they are guarded by `lib.mkIf`. However, only
          # users that have done some customization through `custom.users.<user>.<domain>.<feature>`
          # are affected, so we only disable those defined in `custom.users` by default.
          enable = false;
          # `users.users.csl.group is unset.`
          group = config.users.groups.users.name;
          # `Exactly one of users.users.<name>.isSystemUser and users.users.<name>.isNormalUser must be set.`
          isNormalUser = true;
        }
      );
    };
in
{
  options.custom.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customSubmodule);
    default = { };
  };

  options.users.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customEffectSubmodule);
  };
}
