{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
let
  customCfg = config.custom.system.security.secret;
in
{
  config = lib.mkIf customCfg.enable {
    age.rekey.masterIdentities = [
      {
        identity = (flakeRoot + /secrets/identities/main.key.age);
        pubkey = "age1ke6r2945sh89e6kax2myzahaedwk7647wq4kjn7luwgqg4rgduhsyggmxm";
      }
    ];
    age.rekey.storageMode = "local";
    age.rekey.localStorageDir = flakeRoot + /secrets/rekeyed/hosts/${config.networking.hostName};
  };
}
