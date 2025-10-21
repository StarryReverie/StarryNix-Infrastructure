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

  networking.useNetworkd = true;
  systemd.network.enable = true;

  systemd.network.netdevs."10-microvm".netdevConfig = {
    Kind = "bridge";
    Name = "microvm";
  };

  systemd.network.networks."10-microvm" = {
    matchConfig.Name = "microvm";
    address = [ "172.25.0.254/24" ];
    networkConfig = {
      IPv4Forwarding = true;
    };
  };

  systemd.network.networks."11-microvm" = {
    matchConfig.Name = "vmif-*";
    networkConfig.Bridge = "microvm";
  };

  networking.nat.enable = true;

  networking.firewall.enable = true;
  networking.nftables.enable = true;
  networking.firewall.allowedTCPPorts = [ 8080 ];

  networking.nftables.tables."starrynix-infrastructure-services-nat" = {
    family = "ip";
    content = ''
      set internal-interfaces {
          type ifname;
          elements = { "microvm" }
      }

      set external-interfaces {
          type ifname;
          elements = { "wlp3s0", "tailscale0" }
      }

      map service-port-forwarding {
          typeof meta l4proto . th dport : ip daddr . th dport;
          counter
          elements = {
              tcp . 8080 : 172.25.0.1 . 80
          }
      }

      chain pre {
          type nat hook prerouting priority dstnat; policy accept;
          iifname @external-interfaces meta l4proto { tcp, udp } dnat ip to meta l4proto . th dport map @service-port-forwarding comment "DNAT external requests to internal services"
          iifname "lo" meta l4proto { tcp, udp } dnat ip to meta l4proto . th dport map @service-port-forwarding comment "DNAT external requests to internal services"
      }

      chain postrouting {
          type nat hook postrouting priority srcnat; policy accept;
          iifname @internal-interfaces oifname @external-interfaces counter masquerade comment "SNAT from internal services"
          iifname != @internal-interfaces oifname @internal-interfaces counter masquerade comment "Masquerade for DNAT reflection"
      }

      chain output {
          type nat hook output priority mangle; policy accept;
      }
    '';
  };
}
