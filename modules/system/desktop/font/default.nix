{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.desktop.font;
in
{
  config = lib.mkIf customCfg.enable {
    fonts.packages = [
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans-static
      pkgs.open-sans

      pkgs.libertinus
      pkgs.noto-fonts-cjk-serif-static

      pkgs.cascadia-code
      pkgs.maple-mono.NL-NF-CN-unhinted
      pkgs.source-code-pro

      pkgs.nerd-fonts.symbols-only
      pkgs.noto-fonts-color-emoji
    ];

    fonts.fontDir.enable = true;

    fonts.fontconfig = {
      enable = true;
      localConf = builtins.readFile ./fonts.conf;
    };
  };
}
