{
  config,
  lib,
  pkgs,
  ...
}:
{
  age.secrets."wireless-secrets.env".rekeyFile = ./wireless-secrets.env.age;

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.age.secrets."wireless-secrets.env".path ];

    profiles."BIT-Mobile" = {
      connection = {
        id = "BIT-Mobile";
        type = "wifi";
      };
      wifi = {
        mode = "infrastructure";
        ssid = "BIT-Mobile";
      };
      wifi-security = {
        key-mgmt = "wpa-eap";
      };
      "802-1x" = {
        eap = "peap";
        identity = "$IDENTITY_BIT_MOBILE";
        password = "$PASSWORD_BIT_MOBILE";
        phase2-auth = "mschapv2";
      };
      ipv4 = {
        method = "auto";
        ignore-auto-dns = true;
        route1 = "10.194.0.0/16,10.194.0.1,100";
      };
      ipv6 = {
        method = "auto";
        ignore-auto-dns = true;
        addr-gen-mode = "default";
      };
    };
  };
}
