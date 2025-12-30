{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
let
  userModuleRoot = flakeRoot + /modules/users/starryreverie;
in
{
  imports = [
    # Common user modules
    (userModuleRoot + /alacritty)
    (userModuleRoot + /atuin)
    (userModuleRoot + /bat)
    (userModuleRoot + /clipboard)
    (userModuleRoot + /difftastic)
    (userModuleRoot + /direnv)
    (userModuleRoot + /environment)
    (userModuleRoot + /eza)
    (userModuleRoot + /fastfetch)
    (userModuleRoot + /fd)
    (userModuleRoot + /fzf)
    (userModuleRoot + /git)
    (userModuleRoot + /github-copilot-cli)
    (userModuleRoot + /gtk-theme)
    (userModuleRoot + /helix)
    (userModuleRoot + /hyprlock)
    (userModuleRoot + /lazygit)
    (userModuleRoot + /niri-environment)
    (userModuleRoot + /password)
    (userModuleRoot + /qq)
    (userModuleRoot + /qt-theme)
    (userModuleRoot + /ripgrep)
    (userModuleRoot + /rofi)
    (userModuleRoot + /swaync)
    (userModuleRoot + /vscode)
    (userModuleRoot + /waybar)
    (userModuleRoot + /wpaperd)
    (userModuleRoot + /xdg)
    (userModuleRoot + /yazi)
    (userModuleRoot + /zellij)
    (userModuleRoot + /zoxide)
    (userModuleRoot + /zsh)

    # Host-specific user modules
    ./kanshi.nix
    ./niri-environment.nix
  ];

  users.users.starryreverie = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];

    packages = with pkgs; [
      htop
      nixpkgs-review
    ];
  };

  programs.zsh.enable = true;
}
