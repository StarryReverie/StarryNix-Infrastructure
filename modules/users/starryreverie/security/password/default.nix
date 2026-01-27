{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.security.password;
in
{
  config = lib.mkIf customCfg.enable {
    users.users.starryreverie = {
      hashedPassword = "$y$j9T$JqXWG6rQ/s06t5sPLrO9q.$cajpsiN78j2kwgbZ2WSH4WWFblhUL57qjfFpixt3UP2";
    };
  };
}
