{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  imports = [
    (flakeRoot + /modules/users/common/applications/zsh)
  ];

  users.users.starryreverie = {
    custom.zsh = {
      enable = true;
      alwaysSourceProfile = true;

      rcContent = lib.mkMerge [
        ''
          # ===== Prompt style
          source ${./short-cwd.sh}
          source ${./get-cwd-git-branch.sh}
          setopt prompt_subst
          export PS1='%{%F{226}%}%n%{%F{220}%}@%{%F{214}%}%m%{%F{red}%}$(get-cwd-git-branch) %{%F{45}%}$(short-cwd) %{%F{white}%}($(date +%H:%M))
          %{%f%}> '
          export RPROMPT="%F{red}%(?..%?)%f"
        ''

        ''
          # ===== Zsh autosuggestions
          source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
          ZSH_AUTOSUGGEST_STRATEGY=(history)
        ''

        (lib.mkOrder 1200 ''
          # ===== Zsh syntax highlighting
          # It should be loaded after all other widgets have been loaded.
          source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          ZSH_HIGHLIGHT_HIGHLIGHTERS+=()
        '')
      ];
    };
  };

  preservation.preserveAt."/nix/persistence" = {
    users.starryreverie = {
      files = [
        {
          file = ".zcompdump";
          how = "symlink";
        }
        {
          file = ".zsh_history";
          how = "symlink";
        }
      ];
    };
  };
}
