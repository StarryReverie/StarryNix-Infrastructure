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
    # Console
    {
      console = {
        earlySetup = true;
        packages = with pkgs; [ terminus_font ];
        font = "${pkgs.terminus_font}/share/consolefonts/ter-d24b.psf.gz";
      };
    }

    # ISO image
    {
      isoImage.squashfsCompression = "gzip -Xcompression-level 1";
    }

    # Power Management
    {
      systemd.sleep.settings.Sleep = {
        AllowSuspend = "no";
        AllowHibernation = "no";
        AllowHybridSleep = "no";
        AllowSuspendThenHibernate = "no";
      };
    }
  ];
}
