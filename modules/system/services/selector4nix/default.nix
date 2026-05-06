{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.services.selector4nix;
in
{
  config = lib.mkIf customCfg.enable {
    services.selector4nix.enable = true;

    services.selector4nix.configureSubstituter = "overwrite";

    services.selector4nix.settings = {
      server = {
        ip = "127.0.0.1";
        port = 5496;
      };
      network = {
        max_concurrent_requests = 24;
      };
      substituters = [
        {
          url = "https://cache.nixos.org/";
          priority = 40;
        }
        {
          url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store/";
          priority = 45;
        }
        {
          url = "https://mirrors.ustc.edu.cn/nix-channels/store/";
          priority = 45;
        }
        {
          url = "https://mirror.sjtu.edu.cn/nix-channels/store/";
          priority = 45;
        }
        {
          url = "https://nix-community.cachix.org/";
          priority = 40;
        }
        {
          url = "https://cache.garnix.io/";
          storage_url = "https://garnix-cache.com/";
          priority = 40;
        }
      ];
    };
  };
}
