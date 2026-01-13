{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.nix-ld.enable = true;

  services.envfs.enable = true;

  # See <https://github.com/Mic92/envfs/issues/203>.
  fileSystems."/bin".enable = false;
  fileSystems."/usr/bin".options = [
    "x-systemd.requires=modprobe@fuse.service"
    "x-systemd.after=modprobe@fuse.service"
  ];

  boot.initrd.systemd.tmpfiles.settings = {
    "50-usr-bin" = {
      "/sysroot/usr/bin".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
    };
  };

  environment.variables = {
    ENVFS_RESOLVE_ALWAYS = "1";
  };
}
