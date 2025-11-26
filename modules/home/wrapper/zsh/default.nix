{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    settings.zsh = {
      profileContent = lib.mkOption {
        type = lib.types.lines;
        description = "Zsh scripts to be added to .zprofile, concatenated by `\n`";
        default = "";
        example = "source /path/to/my/script.sh";
      };

      rcContent = lib.mkOption {
        type = lib.types.lines;
        description = "Zsh scripts to be added to .zshrc, concatenated by `\n`";
        default = "";
        example = "source /path/to/my/script.sh";
      };

      shellAliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = "Shell aliases to be added to .zshrc";
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
    };
  };

  config = {
    settings.zsh.profileContent = lib.mkMerge [
      ''
        emulate sh
        [ -f ~/.profile ] && source ~/.profile
        emulate zsh
      ''
    ];

    settings.zsh.rcContent = lib.mkMerge [
      ''
        # Set prompt style
        source ${./short-cwd.sh}
        source ${./get-cwd-git-branch.sh}
        setopt prompt_subst
        export PS1='%{%F{226}%}%n%{%F{220}%}@%{%F{214}%}%m%{%F{red}%}$(get-cwd-git-branch) %{%F{45}%}$(short-cwd) %{%F{white}%}($(date +%H:%M))
        %{%f%}> '
        export RPROMPT="%F{red}%(?..%?)%f"
      ''

      ''
        # History (required since `$ZDOTDIR` now points to an immutable directory in Nix store)
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

      ''
        # Zsh autosuggestions
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        ZSH_AUTOSUGGEST_STRATEGY=(history)
      ''

      ''
        # Zsh completions
        autoload -U compinit && compinit
      ''

      (lib.mkOrder 520 ''
        # Completion Libraries
        for profile in ''${(z)NIX_PROFILES}; do
          fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
        done
      '')

      (lib.mkOrder 1200 ''
        # Zsh syntax highlighting
        # It should be loaded after all other widgets have been loaded.
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS+=()
      '')

      (lib.pipe (lib.attrsToList config.settings.zsh.shellAliases) [
        (builtins.map ({ name, value }: "alias -- ${name}=${lib.escapeShellArg value}"))
        (builtins.concatStringsSep "\n")
      ])
    ];

    wrappers.zsh.basePackage = pkgs.zsh;

    wrappers.zsh.env = {
      ZDOTDIR.value =
        let
          zshProfileFile = pkgs.writeTextDir ".zprofile" config.settings.zsh.profileContent;

          zshRcFile = pkgs.writeTextDir ".zshrc" config.settings.zsh.rcContent;

          zshEnvFile =
            let
              makeEnvironment = { name, value }: "export ${name}=${lib.escapeShellArg value}";
              environmentCommands = builtins.map makeEnvironment (
                lib.attrsToList config.settings.zsh.environment
              );
              zshenvContent = builtins.concatStringsSep "\n" environmentCommands;
            in
            pkgs.writeTextDir ".zshenv" zshenvContent;

          configDirectory = pkgs.symlinkJoin {
            name = "zsh-config-directory";
            paths = [
              zshProfileFile
              zshRcFile
              zshEnvFile
            ];
          };
        in
        configDirectory;
    };

    wrappers.zsh.pathAdd = [
      pkgs.nix-zsh-completions
    ];
  };
}
