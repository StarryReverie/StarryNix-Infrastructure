{
  config,
  lib,
  pkgs,
  ...
}:
let
  getCwdGitBranchScript = pkgs.writeScript "get-cwd-git-branch" (
    builtins.readFile ./get-cwd-git-branch.sh
  );
in
{
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      # Set prompt style
      setopt prompt_subst
      export PS1='%{%F{226}%}%n%{%F{220}%}@%{%F{214}%}%m%{%F{red}%}$(${getCwdGitBranchScript}) %{%F{45}%}%~ %{%F{white}%}($(date +%H:%M))
      %{%f%}> '

      export RPROMPT="%F{red}%(?..%?)%f"
    '';
  };
}
