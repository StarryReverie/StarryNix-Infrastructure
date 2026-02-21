{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.security.password or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie = {
      hashedPassword = "$y$j9T$JqXWG6rQ/s06t5sPLrO9q.$cajpsiN78j2kwgbZ2WSH4WWFblhUL57qjfFpixt3UP2";
    };
  };
}
