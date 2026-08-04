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
  vaultix.settings.hostPubkey =
    if nodeCfg.nodeInformation.sshKey.publicKeyFile != null then
      builtins.readFile nodeCfg.nodeInformation.sshKey.publicKeyFile
    else
      "";
}
