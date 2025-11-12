{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    wrapperConfigurations = {
      finalPackages = lib.mkOption {
        type = lib.types.attrsOf lib.types.raw;
        description = "The resulting wrapper package set";
        readOnly = true;
      };
    };
  };

  config = { };
}
