{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.hardware.nvidia-graphics;
in
{
  options.custom.hardware.nvidia-graphics = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable NVIDIA driver";
      default = false;
      example = true;
    };

    prime = lib.mkOption {
      type = lib.types.enum [
        "disabled"
        "offload"
        "sync"
      ];
      description = "The type of PRIME to use";
      default = "disabled";
      example = "offload";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf customCfg.enable {
      services.xserver.videoDrivers = [ "nvidia" ];

      boot.blacklistedKernelModules = [ "nouveau" ];

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          linux-firmware
        ];
      };

      hardware.nvidia = {
        open = false;
        nvidiaSettings = false;
        modesetting.enable = true;
        powerManagement.enable = true;
        dynamicBoost.enable = true;
      };
    })

    (lib.mkIf (customCfg.enable && customCfg.prime == "offload") {
      hardware.nvidia = {
        prime.offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        powerManagement.finegrained = true;
      };
    })

    (lib.mkIf (customCfg.enable && customCfg.prime == "sync") {
      hardware.nvidia = {
        prime.sync = {
          enable = true;
        };
      };
    })
  ];
}
