{
  config,
  lib,
  pkgs,
  constants,
  flakeRoot,
  ...
}:
{
  networking.useDHCP = true;
  networking.useNetworkd = true;
  systemd.network.enable = true;
  # networking.networkmanager.enable = true;

  networking.wireless = {
    enable = true;
    secretsFile = config.age.secrets."wireless-password.conf".path;
    networks."BIT-Mobile".auth = ''
      key_mgmt=WPA-EAP
      eap=PEAP
      phase2="auth=MSCHAPV2"
      identity="1120233608"
      password=ext:pass_BIT-Mobile
    '';
    extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";
    allowAuxiliaryImperativeNetworks = true;
  };

  age.secrets = {
    "wireless-password.conf".rekeyFile = flakeRoot + /secrets/wireless-password.conf.age;
  };

  services.dae.wanInterfaces = [ "wlo1" ];
}
