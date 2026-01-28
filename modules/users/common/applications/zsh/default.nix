{
  config,
  lib,
  pkgs,
  ...
}:
let
  customZshSubmodule =
    { name, ... }:
    let
      selfCfg = config.custom.users.${name};
      customCfg = selfCfg.applications.zsh;
    in
    {
      options.applications.zsh = {
        profileContent = lib.mkOption {
          type = lib.types.lines;
          description = "Zsh scripts to be added to `.zprofile`, concatenated by `\n`";
          default = "";
          example = "source /path/to/my/script.sh";
        };

        rcContent = lib.mkOption {
          type = lib.types.lines;
          description = "Zsh scripts to be added to `.zshrc`, concatenated by `\n`";
          default = "";
          example = "source /path/to/my/script.sh";
        };

        shellAliases = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "Shell aliases to be added to `.zshrc`";
          default = { };
          example = {
            ll = "ls -l";
          };
        };

        environment = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "Environment variables to be set when zsh starts";
          default = { };
          example = {
            EDITOR = "hx";
          };
        };

        alwaysSourceProfile = lib.mkOption {
          type = lib.types.bool;
          description = ''
            Always try to source `.zprofile` in a interative shell, no matter
            whether it is a login shell or not
          '';
          default = false;
          example = true;
        };
      };

      config = lib.mkIf customCfg.enable {
        applications.zsh = {
          profileContent = lib.mkMerge [
            (lib.mkOrder 300 ''
              # ===== Prevent `.zprofile` from being sourced again
              if [ -n "$__ZPROFILE_SOURCED" ]; then
                return
              fi
              export __ZPROFILE_SOURCED=1
            '')

            ''
              # ===== Load `.profile`
              # Do as what `sh` and `bash` do, ensuring more consistent UX.
              emulate sh
              [ -f ~/.profile ] && source ~/.profile
              emulate zsh
            ''
          ];

          rcContent = lib.mkMerge (
            [
              ''
                # ===== History
                HISTSIZE="10000"
                SAVEHIST="10000"
                HISTFILE="$HOME/.zsh_history"

                enabled_opts=(
                    HIST_FCNTL_LOCK HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
                )
                for opt in "''${enabled_opts[@]}"; do
                    setopt "$opt"
                done
                unset opt enabled_opts

                disabled_opts=(
                    APPEND_HISTORY EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS
                    HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS
                )
                for opt in "''${disabled_opts[@]}"; do
                    unsetopt "$opt"
                done
                unset opt disabled_opts
              ''

              (lib.mkOrder 520 ''
                # ===== Completion libraries
                for profile in ''${(z)NIX_PROFILES}; do
                    fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
                done
              '')

              ''
                # ===== Zsh completions
                autoload -Uz compinit
                autoload -Uz zrecompile
                compdump_file=$HOME/.zcompdump
                if [[ -s $compdump_file(#qN.mh+24) && (! -s "$compdump_file.zwc" || "$compdump_file" -nt "$compdump_file.zwc") ]]; then
                    compinit -i -d $compdump_file
                    zrecompile $compdump_file
                fi
                compinit -C -d $compdump_file
              ''

              ''
                # ===== Shell aliases
                ${
                  (lib.pipe customCfg.shellAliases [
                    (lib.attrsets.mapAttrsToList (name: value: "alias -- ${name}=${lib.strings.escapeShellArg value}"))
                    (lib.strings.concatStringsSep "\n")
                  ])
                }
              ''
            ]
            ++ lib.optionals customCfg.alwaysSourceProfile [
              (lib.mkOrder 300 ''
                profile_path=''${ZDOTDIR:-$HOME}/.zprofile
                [ -f $profile_path ] && source $profile_path
              '')
            ]
          );
        };
      };
    };

  customZshEffectSubmodule =
    { name, ... }:
    let
      selfCfg = config.custom.users.${name} or { };
      customCfg = selfCfg.applications.zsh or { };
    in
    {
      config = lib.mkIf (customCfg.enable or false) {
        shell = pkgs.zsh;

        maid = {
          file.home.".zprofile".text = customCfg.profileContent;
          file.home.".zshrc".text = customCfg.rcContent;

          file.home.".zshenv".text = lib.pipe customCfg.environment [
            (lib.attrsets.mapAttrsToList (name: value: "export ${name}=${lib.strings.escapeShellArg value}"))
            (lib.strings.concatStringsSep "\n")
          ];
        };
      };
    };
in
{
  options.custom.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customZshSubmodule);
  };

  options.users.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customZshEffectSubmodule);
  };
}
