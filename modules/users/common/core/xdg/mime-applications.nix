{
  config,
  lib,
  pkgs,
  ...
}:
let
  customXdgSubmodule =
    { name, ... }:
    let
      selfCfg = config.custom.users.${name};
      customCfg = selfCfg.core.xdg;
    in
    {
      options.core.xdg.mimeApplications = {
        default = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "Default applications for each MIME types";
          default = { };
          example = {
            "text/html" = "firefox.desktop";
            "image/png" = "org.gnome.Loupe.desktop";
            "x-scheme-handler/https" = "firefox.desktop";
          };
        };

        added = lib.mkOption {
          type = lib.types.attrsOf (lib.types.listOf lib.types.str);
          description = "Added applications for each MIME types";
          default = { };
          example = {
            "text/plain" = [ "gedit.desktop" ];
            "application/pdf" = [ "org.gnome.Evince.desktop" ];
          };
        };

        removed = lib.mkOption {
          type = lib.types.attrsOf (lib.types.listOf lib.types.str);
          description = "Removed applications for each MIME types";
          default = { };
          example = {
            "text/plain" = [ "nano.desktop" ];
            "x-scheme-handler/http" = [ "chromium-browser.desktop" ];
          };
        };
      };
    };

  customXdgEffectSubmodule =
    { name, ... }:
    let
      selfCfg = config.custom.users.${name} or { };
      customCfg = selfCfg.core.xdg or { };
    in
    {
      config = lib.mkIf (customCfg.enable or false) {
        maid = {
          file.xdg_config."mimeapps.list".text =
            let
              defaultAppsContent = lib.pipe customCfg.mimeApplications.default [
                (lib.mapAttrsToList (mime: app: "${mime}=${app}"))
                (builtins.concatStringsSep "\n")
              ];

              addedAppsContent = lib.pipe customCfg.mimeApplications.added [
                (lib.mapAttrsToList (mime: apps: "${mime}=${builtins.concatStringsSep ";" apps}"))
                (builtins.concatStringsSep "\n")
              ];

              removedAppsContent = lib.pipe customCfg.mimeApplications.removed [
                (lib.mapAttrsToList (mime: apps: "${mime}=${builtins.concatStringsSep ";" apps}"))
                (builtins.concatStringsSep "\n")
              ];

              fileContent = ''
                [Default Applications]
                ${defaultAppsContent}

                [Added Applications]
                ${addedAppsContent}

                [Removed Applications]
                ${removedAppsContent}
              '';
            in
            fileContent;
        };
      };
    };
in
{
  options.custom.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customXdgSubmodule);
  };

  options.users.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customXdgEffectSubmodule);
  };
}
