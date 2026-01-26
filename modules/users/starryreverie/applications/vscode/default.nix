{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.applications.vscode;
in
{
  config = lib.mkIf customCfg.enable {
    users.users.starryreverie.maid = {
      packages = [
        (inputs.wrapper-manager.lib.wrapWith pkgs {
          basePackage = pkgs.vscode-with-extensions.override {
            vscode = pkgs.vscodium;
            vscodeExtensions = with pkgs.vscode-extensions; [
              charliermarsh.ruff
              davidanson.vscode-markdownlint
              editorconfig.editorconfig
              jeff-hykin.better-nix-syntax
              jnoortheen.nix-ide
              mechatroner.rainbow-csv
              mkhl.direnv
              ms-pyright.pyright
              ms-python.python
              mskelton.one-dark-theme
              myriad-dreamin.tinymist
              rust-lang.rust-analyzer
              tamasfe.even-better-toml
              tekumara.typos-vscode
              timonwong.shellcheck
              usernamehw.errorlens
              yzhang.dictionary-completion
            ];
          };

          prependFlags = [
            "--disable-gpu"
          ];
        })
      ];

      file.xdg_config."VSCodium/User/settings.json".source = ./settings.jsonc;
    };

    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".config/VSCodium" ];
      };
    };
  };
}
