{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.openssh = {
    ports = [
      22
      2222
    ];
  };
}
