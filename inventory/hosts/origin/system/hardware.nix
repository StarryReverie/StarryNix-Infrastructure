{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  config = lib.mkMerge [
    # ISO image
    {
      isoImage.squashfsCompression = "gzip -Xcompression-level 1";
    }
  ];
}
