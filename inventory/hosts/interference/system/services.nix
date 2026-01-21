{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    # OpenSSH
    {
      services.openssh.ports = [
        22
        2222
      ];
    }
  ];
}
