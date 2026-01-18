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
    rootCredentialsFile = config.age.secrets."minio-root-credentials".path;
  };

  age.secrets."minio-root-credentials" = {
    rekeyFile = ./secrets/minio-root-credentials.age;
    owner = "minio";
  };
}
