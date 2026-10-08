{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.core.nix;
in
{
  config = lib.mkIf customCfg.enable {
    nix.settings.substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"

      "https://drvgraph.cachix.org"
      "https://selector4nix.cachix.org"
      "https://starrynix-derivations.cachix.org/"
    ];

    nix.settings.trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "drvgraph.cachix.org-1:OngTuA0ekssxvRfZnRAvq1shmPRfJu3EO135RcbUvBg="
      "selector4nix.cachix.org-1:wovVlT07In5JCVz2tFgxPQTLpnN8hZT6P/RwfFcz3KE="
      "starrynix-derivations.cachix.org-1:xeKb1mqP+suib++KMMe64pofNgsSgDJQLgcV2FVNZ2s="
    ];
  };
}
