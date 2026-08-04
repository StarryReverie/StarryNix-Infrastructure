{
  config,
  lib,
  pkgs,
  ...
}:
let
  nodeCfg = config.starrynix-infrastructure.node;
in
{
  services.redis.servers."nextcloud" = {
    enable = true;
    databases = 1;
    bind = nodeCfg.nodeInformation.ipv4Address;
    port = 6379;
    openFirewall = true;
    requirePassFile = config.vaultix.secrets."redis-password".path;
    save = [ ];
  };

  vaultix.secrets."redis-password" = {
    file = ./secrets/redis-password.age;
    owner = config.services.redis.servers."nextcloud".user;
  };
}
