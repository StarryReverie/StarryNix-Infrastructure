{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie = {
    maid = {
      packages = with pkgs; [
        orchis-theme
        reversal-icon-theme
        vimix-cursors
      ];

      dconf.settings = {
        "/org/gnome/desktop/interface/gtk-theme" = "Orchis-Dark";
        "/org/gnome/desktop/interface/icon-theme" = "Reversal-dark";
        "/org/gnome/desktop/interface/cursor-theme" = "Vimix-cursors";
        "/org/gnome/desktop/interface/color-scheme" = "prefer-dark";
      };

      file.home.".gtkrc-2.0".text = ''
        gtk-theme-name="Orchis-Dark"
        gtk-icon-theme-name="Reversal-dark"
        gtk-cursor-theme-name="Vimix-cursors"
      '';

      file.xdg_config."gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name = Orchis-Dark
        gtk-icon-theme-name = Reversal-dark
        gtk-cursor-theme-name = Vimix-cursors
        gtk-application-prefer-dark-theme = true
      '';

      file.xdg_config."gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name = Orchis-Dark
        gtk-icon-theme-name = Reversal-dark
        gtk-cursor-theme-name = Vimix-cursors
        gtk-application-prefer-dark-theme = true
      '';

      file.xdg_data."icons/default/index.theme".text = ''
        [Icon Theme]
        Name = Default
        Inherits = Vimix-cursors
      '';
    };

    custom.environment = {
      sessionVariables = {
        GTK_THEME = "Orchis-Dark";
        XCURSOR_THEME = "Vimix-cursors";
      };
    };
  };
}
