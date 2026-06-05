{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.virtualization.libvirt;
in
{
  config = lib.mkIf customCfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };
    virtualisation.spiceUSBRedirection.enable = true;

    programs.virt-manager.enable = true;

    networking.firewall.trustedInterfaces = [ "virbr0" ];

    custom.system.services.transparentProxy = {
      lanInterfaces = [ "virbr0" ];
    };

    preservation.preserveAt."/nix/persistence" = {
      directories = [ "/var/lib/libvirt" ];
    };
  };
}
