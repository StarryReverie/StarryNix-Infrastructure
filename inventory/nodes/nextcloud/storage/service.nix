{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.firewall.allowedTCPPorts = [ 9000 ];

  services.minio = {
    enable = true;
    browser = false;
    rootCredentialsFile = config.vaultix.secrets."minio-root-credentials".path;
  };

  vaultix.secrets."minio-root-credentials" = {
    file = ./secrets/minio-root-credentials.age;
    owner = "minio";
  };
}
