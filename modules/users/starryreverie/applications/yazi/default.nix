{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie = {
    maid = {
      packages = with pkgs; [ yazi ];

      file.xdg_config."yazi/yazi.toml".source = ./yazi.toml;
      file.xdg_config."yazi/keymap.toml".source = ./keymap.toml;
      file.xdg_config."yazi/theme.toml".source = ./theme.toml;
      file.xdg_config."yazi/init.lua".source = ./init.lua;

      file.xdg_config."yazi/flavors/onedark.yazi".source = pkgs.fetchFromGitHub {
        owner = "BennyOe";
        repo = "onedark.yazi";
        rev = "668d71d967857392012684c7dd111605cfa36d1a";
        hash = "sha256-tfkzVa+UdUVKF2DS1awEusfoJEjJh40Bx1cREPtewR0=";
      };
    };

    custom.applications.zsh = {
      rcContent = ''
        # ===== Yazi integration
        function dk() {
            local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
            ${lib.getExe pkgs.yazi} "$@" --cwd-file="$tmp"
            IFS= read -r -d "" cwd < "$tmp"
            [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
            rm -f -- "$tmp"
        }
      '';
    };
  };
}
