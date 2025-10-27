{
  config,
  lib,
  pkgs,
  ...
}:
let
  registryCfg = config.starrynix-infrastructure.registry;
  nodeCfg = config.starrynix-infrastructure.node;
in
{
  age.rekey.masterIdentities = registryCfg.secret.masterIdentities;

  age.rekey.storageMode = "local";
  age.rekey.localStorageDir = registryCfg.secret.localStorageDir + nodeCfg.nodeInformation.hostName;

  age.rekey.hostPubkey =
    if nodeCfg.nodeInformation.sshKey.publicKeyFile != null then
      builtins.readFile nodeCfg.nodeInformation.sshKey.publicKeyFile
    else
      "";
}
