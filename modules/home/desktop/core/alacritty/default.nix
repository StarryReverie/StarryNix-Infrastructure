{ config, lib, pkgs, ... }@args:

let
  flags = config.flags.packages.desktop;

  colorscheme = if config.flags.ui.colorscheme == "Tokyo Night Storm" then
    "tokyo-night-storm"
  else if config.flags.ui.colorscheme == "One Dark" then
    "one-dark"
  else
    builtins.abort "Unreachable";
in {
  programs.alacritty.enable = flags.enable;

  programs.alacritty.settings = {
    font.size = 10.5;
    selection.semantic_escape_chars = '',.?│`|:;"' ()[]{}<>	!@#$%^&*-=+/~'';
    keyboard.bindings = import ./keybindings.nix args;
    colors = import ./themes/${colorscheme}.nix args;

    window = {
      decorations = "None";
      opacity = 0.7;
      blur = true;
      startup_mode = "Maximized";

      padding = {
        x = 16;
        y = 10;
      };
    };
  };
}
