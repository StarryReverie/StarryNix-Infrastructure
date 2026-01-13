{
  config,
  lib,
  pkgs,
  ...
}:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans-static
    open-sans

    libertinus
    noto-fonts-cjk-serif-static

    cascadia-code
    maple-mono.NL-NF-CN-unhinted
    source-code-pro

    nerd-fonts.symbols-only
    noto-fonts-color-emoji
  ];

  fonts.fontDir.enable = true;

  fonts.fontconfig = {
    enable = true;
    localConf = builtins.readFile ./fonts.conf;
  };
}
