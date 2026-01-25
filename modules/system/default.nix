{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkEntry = domain: feature: {
    ${domain}.${feature}.enable = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether to system-scoped feature option `custom.${domain}.${feature}`.
        If at least one `users.users.<user>.custom.${domain}.${feature}.enable`
        exists and is set to `true`, then this option will be enabled as well
        by default.
      '';
      default = lib.pipe config.users.users [
        lib.attrsets.attrValues
        (lib.lists.map (cfg: cfg.custom.${domain}.${feature}.enable or false))
        (lib.lists.any lib.id)
      ];
      defaultText = ''
        `true` if any of `users.users.<name>.custom.${domain}.${feature}.enable`
        is `true`, otherwise `false`
      '';
      example = true;
    };
  };
in
{
  options.custom = lib.attrsets.foldAttrs lib.attrsets.recursiveUpdate { } [
    (mkEntry "applications" "alacritty")
    (mkEntry "applications" "firefox")
    (mkEntry "applications" "git")
    (mkEntry "applications" "github-copilot-cli")
    (mkEntry "applications" "helix")
    (mkEntry "applications" "keepassxc")
    (mkEntry "applications" "lazygit")
    (mkEntry "applications" "lx-music-desktop")
    (mkEntry "applications" "mpv")
    (mkEntry "applications" "nautilus")
    (mkEntry "applications" "qq")
    (mkEntry "applications" "resources")
    (mkEntry "applications" "telegram-desktop")
    (mkEntry "applications" "vscode")
    (mkEntry "applications" "yazi")
    (mkEntry "applications" "zellij")
    (mkEntry "applications" "zsh")
    (mkEntry "core" "etc-overlay")
    (mkEntry "core" "fhs-compatibility")
    (mkEntry "core" "initrd")
    (mkEntry "core" "nix")
    (mkEntry "core" "preservation")
    (mkEntry "core" "user-management")
    (mkEntry "core" "xdg")
    (mkEntry "desktop" "clipboard")
    (mkEntry "desktop" "fcitx5")
    (mkEntry "desktop" "font")
    (mkEntry "desktop" "gtk-theme")
    (mkEntry "desktop" "hyprlock")
    (mkEntry "desktop" "niri-environment")
    (mkEntry "desktop" "qt-theme")
    (mkEntry "desktop" "rofi")
    (mkEntry "desktop" "swaync")
    (mkEntry "desktop" "waybar")
    (mkEntry "desktop" "wpaperd")
    (mkEntry "hardware" "bluetooth")
    (mkEntry "hardware" "intel-graphics")
    (mkEntry "hardware" "keyd")
    (mkEntry "hardware" "networking")
    (mkEntry "hardware" "nvidia-graphics")
    (mkEntry "hardware" "pipewire")
    (mkEntry "hardware" "tlp")
    (mkEntry "hardware" "wireless")
    (mkEntry "hardware" "zram-swap")
    (mkEntry "programs" "atuin")
    (mkEntry "programs" "bat")
    (mkEntry "programs" "diffitastic")
    (mkEntry "programs" "direnv")
    (mkEntry "programs" "eza")
    (mkEntry "programs" "fastfetch")
    (mkEntry "programs" "fd")
    (mkEntry "programs" "fzf")
    (mkEntry "programs" "ripgrep")
    (mkEntry "programs" "zoxide")
    (mkEntry "security" "fail2ban")
    (mkEntry "security" "password")
    (mkEntry "security" "secret")
    (mkEntry "security" "sudo")
    (mkEntry "services" "dconf")
    (mkEntry "services" "dnsproxy")
    (mkEntry "services" "ly")
    (mkEntry "services" "mpd-ecosystem")
    (mkEntry "services" "openssh")
    (mkEntry "services" "tailscale")
    (mkEntry "services" "transparent-proxy")
    (mkEntry "virtualization" "container")
    (mkEntry "virtualization" "distrobox")
    (mkEntry "virtualization" "waydroid")
  ];
}
