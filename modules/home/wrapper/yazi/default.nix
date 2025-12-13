{
  config,
  lib,
  pkgs,
  ...
}:
{
  wrappers.yazi.basePackage =
    pkgs.runCommand "yazi-without-desktop-item" { nativeBuildInputs = [ pkgs.yazi-unwrapped ]; }
      ''
        mkdir -p $out
        (cd ${pkgs.yazi-unwrapped} && tar -chf - --exclude="share/applications/yazi.desktop" .) \
            | (cd $out && tar -xf -)
      '';

  wrappers.yazi.postBuild = ''
    mkdir -p $out/share/applications
    sed -E -e "s#Exec=((/.*)*/)?yazi#Exec=$out/bin/yazi#" \
        ${pkgs.yazi-unwrapped}/share/applications/yazi.desktop \
        > $out/share/applications/yazi.desktop
  '';

  wrappers.yazi.overrideAttrs = prev: {
    pname = "yazi";
  };

  wrappers.yazi.pathAdd = [
    config.wrappers.fzf.wrapped
    config.wrappers.ripgrep.wrapped
    pkgs.zoxide
    pkgs.fd
    pkgs.jq
  ];

  wrappers.yazi.env = {
    YAZI_CONFIG_HOME.value =
      let
        yaziFlavorOneDark = pkgs.fetchFromGitHub {
          owner = "BennyOe";
          repo = "onedark.yazi";
          rev = "668d71d967857392012684c7dd111605cfa36d1a";
          hash = "sha256-tfkzVa+UdUVKF2DS1awEusfoJEjJh40Bx1cREPtewR0=";
        };

        configDir = pkgs.runCommand "yazi-config-dir" { nativeBuildInputs = [ yaziFlavorOneDark ]; } ''
          mkdir -p $out
          cp ${./yazi.toml} $out/yazi.toml
          cp ${./keymap.toml} $out/keymap.toml
          cp ${./theme.toml} $out/theme.toml
          cp ${./init.lua} $out/init.lua

          mkdir -p $out/flavors/onedark.yazi
          cp ${yaziFlavorOneDark}/{flavor.toml,tmtheme.xml} $out/flavors/onedark.yazi
        '';
      in
      configDir;
  };

  settings.zsh.rcContent = ''
    function dk() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d "" cwd < "$tmp"
        [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
    }
  '';
}
