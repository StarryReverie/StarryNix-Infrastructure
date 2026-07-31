{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.vscode or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = [
        (inputs.wrapper-manager.lib.wrapWith pkgs {
          basePackage = pkgs.vscode-with-extensions.override {
            vscode = pkgs.vscodium;
            vscodeExtensions = with pkgs.vscode-extensions; [
              # General
              editorconfig.editorconfig
              mkhl.direnv
              mskelton.one-dark-theme
              tamasfe.even-better-toml
              tekumara.typos-vscode
              usernamehw.errorlens
              yzhang.dictionary-completion

              # Nix
              jeff-hykin.better-nix-syntax
              jnoortheen.nix-ide

              # Frontend
              bradlc.vscode-tailwindcss
              prettier.prettier-vscode
              samuelcolvin.jinjahtml

              # Typography
              davidanson.vscode-markdownlint
              myriad-dreamin.tinymist

              # Misc
              timonwong.shellcheck
              mechatroner.rainbow-csv
            ];
          };

          prependFlags = [
            "--disable-gpu"
          ];
        })
      ];

      file.xdg_config."VSCodium/User/settings.json".source = ./settings.jsonc;
      file.xdg_config."VSCodium/User/keybindings.json".source = ./keybindings.jsonc;
    };

    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".config/VSCodium" ];
      };
    };
  };
}
