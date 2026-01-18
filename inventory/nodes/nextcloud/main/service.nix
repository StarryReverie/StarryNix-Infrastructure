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
  networking.firewall.allowedTCPPorts = [ 80 ];

  services.nextcloud = {
    enable = true;
    hostName = "0.0.0.0";

    database.createLocally = true;
    secretFile = config.age.secrets."secret-configurations".path;

    config = {
      adminpassFile = config.age.secrets."nextcloud-admin-password".path;
      dbtype = "pgsql";

      objectstore.s3 = {
        enable = true;
        hostname = nodeCfg.clusterInformation.nodes."storage".ipv4Address;
        port = 9000;
        useSsl = false;
        bucket = "nextcloud";
        usePathStyle = true;
        key = "nextcloud";
        secretFile = config.age.secrets."minio-secret".path;
        region = "us-east-1";
      };
    };

    settings = {
      trusted_domains = [ "topological" ];
      trusted_proxies = [ nodeCfg.clusterInformation.gatewayIpv4Address ];
      log_type = "systemd";

      redis = {
        host = lib.mkForce nodeCfg.clusterInformation.nodes."cache".ipv4Address;
        port = lib.mkForce 6379;
        dbindex = 0;
        timeout = 5;
      };
    };

    configureRedis = true;
    caching.redis = true;

    phpOptions."realpath_cache_size" = "0";
  };

  age = {
    secrets."nextcloud-admin-password" = {
      rekeyFile = ./secrets/nextcloud-admin-password.age;
      owner = "nextcloud";
    };

    secrets."minio-secret" = {
      rekeyFile = ./secrets/minio-secret.age;
      owner = "nextcloud";
    };

    secrets."secret-configurations" = {
      rekeyFile = ./secrets/secret-configurations.age;
      owner = "nextcloud";
    };
  };
}
