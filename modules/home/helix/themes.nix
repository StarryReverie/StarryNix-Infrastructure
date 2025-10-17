{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.helix.themes.one-dark-transparent = {
    inherits = "onedark";

    comment = "#939496";

    "ui.background" = {
      fg = "foreground";
    };
    "ui.cursorline.primary" = {
      bg = "cursorline";
    };
    "ui.cursor.match" = {
      fg = "foreground";
      bg = "light-gray";
    };
    "ui.menu" = {
      fg = "brighter-gray";
      bg = "light-black";
    };
    "ui.menu.selected" = {
      fg = "white";
      bg = "gray";
    };
    "ui.help" = {
      fg = "foreground";
    };
    "ui.popup" = {
      fg = "brighter-gray";
      bg = "light-black";
    };
    "ui.statusline" = {
      fg = "foreground";
    };
    "ui.statusline.inactive" = {
      fg = "light-gray";
    };
    "ui.window" = {
      fg = "light-gray";
      bg = "light-black";
    };

    palette = {
      brighter-gray = "#8e98ab";
    };
  };

  programs.helix.themes.tokyo-night-storm-transparent = {
    inherits = "tokyonight_storm";

    "ui.background" = {
      fg = "foreground";
    };
    "ui.cursorline.primary" = {
      bg = "cursorline";
    };
    "ui.cursor.match" = {
      fg = "foreground";
      bg = "light-gray";
    };
    "ui.menu" = {
      fg = "brighter-gray";
      bg = "light-black";
    };
    "ui.menu.selected" = {
      fg = "white";
      bg = "gray";
    };
    "ui.help" = {
      fg = "foreground";
    };
    "ui.popup" = {
      fg = "brighter-gray";
      bg = "light-black";
    };
    "ui.statusline" = {
      fg = "foreground";
    };
    "ui.statusline.inactive" = {
      fg = "light-gray";
    };
    "ui.window" = {
      fg = "light-gray";
      bg = "light-black";
    };

    palette = {
      background_highlight = "#6c76a6";
      foreground_gutter = "#6c76a6";
      comment = "#b6bbd3";
    };
  };
}
