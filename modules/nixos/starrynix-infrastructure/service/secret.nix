{
  config,
  lib,
  pkgs,
  ...
}:
let
  registryCfg = config.starrynix-infrastructure.registry;
  serviceCfg = config.starrynix-infrastructure.service;
in
{
  age.rekey.masterIdentities = registryCfg.secret.masterIdentities;

  age.rekey.storageMode = "local";
  age.rekey.localStorageDir =
    registryCfg.secret.localStorageDir + serviceCfg.nodeInformation.hostName;

  age.rekey.hostPubkey =
    if serviceCfg.nodeInformation.sshKey.publicKeyFile != null then
      builtins.readFile serviceCfg.nodeInformation.sshKey.publicKeyFile
    else
      "";
}
