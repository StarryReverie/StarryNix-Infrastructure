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
    requirePassFile = config.age.secrets."redis-password".path;
    save = [ ];
  };

  age.secrets."redis-password" = {
    rekeyFile = ./secrets/redis-password.age;
    owner = config.services.redis.servers."nextcloud".user;
  };
}
