{
  config,
  lib,
  pkgs,
  constants,
  ...
}:

{
  networking.useDHCP = lib.mkDefault true;

  networking.wireless = {
    enable = true;
    secretsFile = "/etc/nixos/wireless.conf";
    networks."BIT-Mobile".auth = ''
      key_mgmt=WPA-EAP
      eap=PEAP
      phase2="auth=MSCHAPV2"
      identity="1120233608"
      password=ext:pass_university
    '';
    extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";
    allowAuxiliaryImperativeNetworks = true;
  };

}
