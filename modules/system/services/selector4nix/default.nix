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
    services.selector4nix.enablePersistentCaching = true;

    services.selector4nix.settings = {
      server = {
        ip = "127.0.0.1";
        port = 5496;
      };
      cache = {
        nar_info_lookup_capacity = 8192;
        nar_info_lookup_ttl_secs = 86400;
        nar_location_capacity = 8192;
        nar_location_ttl_secs = 86400;
      };
      substituters = [
        {
          url = "https://cache.nixos.org/";
          priority = 40;
        }
        {
          url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store/";
          priority = 60;
        }
        {
          url = "https://mirrors.ustc.edu.cn/nix-channels/store/";
          priority = 50;
        }
        {
          url = "https://mirror.sjtu.edu.cn/nix-channels/store/";
          priority = 50;
        }
        {
          url = "https://colmena.cachix.org/";
          priority = 40;
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
