{
  config,
  lib,
  pkgs,
  ...
}:
{
  systemd.network.enable = true;
  networking.useNetworkd = true;

  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  # Partially sourced from configurations in nixpkgs
  systemd.network.networks."99-ethernet-default-dhcp" = {
    # Original configurations, duplicated in case that these settings are not
    # enabled due to `networking.useDHCP = false`. Disabling DHCP is required
    # if NetworkManager is enabled. But NetworkManager only manages wireless
    # interfaces as specified in this repository, thus DHCP settings for
    # ethernets should be kept.
    matchConfig = {
      Type = "ether";
      Kind = "!*";
    };
    DHCP = "yes";
    networkConfig.IPv6PrivacyExtensions = "kernel";

    # Additional configurations
    dhcpV4Config.UseDNS = false;
    dhcpV6Config.UseDNS = false;
  };
}
