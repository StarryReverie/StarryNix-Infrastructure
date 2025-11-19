{ config, lib, pkgs, constants, ... }:

{
  flags = lib.mkForce {
    ui = {
      font = {
        notoFonts = true;
        code.main = "Cascadia Mono";
        code.sourceCodePro = true;
        code.cascadiaCode = true;
        emoji = true;
      };
    };
    packages = {
      desktop = {
        environment.plasma.enable = true;
        # environment.enable = true;

        communication.enable = true;
        i18n.enable = true;
        multimedia.enable = true;
        network.enable = true;
        production.enable = true;
      };

      development = {
        enable = true;
      };

      services = {
        enable = true;
        bluetooth.enable = true;
        network.enable = true;
        proxy.enable = true;
        sound.enable = true;
        ssh.enable = true;
      };
    };
  };
}
