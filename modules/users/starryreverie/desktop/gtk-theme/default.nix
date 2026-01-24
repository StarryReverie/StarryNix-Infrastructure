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
        adw-gtk3
        gnome-themes-extra
        reversal-icon-theme
        vimix-cursors
      ];

      gsettings.settings = {
        org.gnome.desktop.interface = {
          gtk-theme = "adw-gtk3-dark";
          icon-theme = "Reversal-dark";
          cursor-theme = "Vimix-cursors";
          color-scheme = "prefer-dark";
        };
      };

      file.xdg_config."gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name = adw-gtk3-dark
        gtk-icon-theme-name = Reversal-dark
        gtk-cursor-theme-name = Vimix-cursors
        gtk-application-prefer-dark-theme = true
      '';

      file.xdg_config."gtk-4.0/assets".source =
        pkgs.adw-gtk3 + /share/themes/adw-gtk3-dark/gtk-4.0/assets;
      file.xdg_config."gtk-4.0/gtk.css".source =
        pkgs.adw-gtk3 + /share/themes/adw-gtk3-dark/gtk-4.0/gtk.css;
      file.xdg_config."gtk-4.0/gtk-dark.css".source =
        pkgs.adw-gtk3 + /share/themes/adw-gtk3-dark/gtk-4.0/gtk-dark.css;
      file.xdg_config."gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name = adw-gtk3-dark
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

    custom.core.environment = {
      sessionVariables = {
        XCURSOR_THEME = "Vimix-cursors";
      };
    };
  };
}
