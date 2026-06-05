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
        Whether to enable system-scoped feature option `custom.system.${domain}.${feature}`. If at
        least one `custom.users.<user>.${domain}.${feature}.enable` exists and is set to `true`,
        then this option will be enabled as well by default.
      '';
      default = lib.pipe config.custom.users [
        lib.attrsets.attrValues
        (lib.lists.map (cfg: cfg.${domain}.${feature}.enable or false))
        (lib.lists.any lib.id)
      ];
      defaultText = ''
        `true` if any of `custom.users.<name>.${domain}.${feature}.enable` is `true`, `false`
        otherwise
      '';
      example = true;
    };
  };
in
{
  options.custom.system = lib.attrsets.foldAttrs lib.attrsets.recursiveUpdate { } [
    (mkEntry "applications" "alacritty")
    (mkEntry "applications" "bottles")
    (mkEntry "applications" "cava")
    (mkEntry "applications" "firefox")
    (mkEntry "applications" "git")
    (mkEntry "applications" "github-copilot-cli")
    (mkEntry "applications" "helix")
    (mkEntry "applications" "htop")
    (mkEntry "applications" "keepassxc")
    (mkEntry "applications" "lazygit")
    (mkEntry "applications" "lx-music-desktop")
    (mkEntry "applications" "mpv")
    (mkEntry "applications" "nautilus")
    (mkEntry "applications" "opencode")
    (mkEntry "applications" "qq")
    (mkEntry "applications" "resources")
    (mkEntry "applications" "splayer")
    (mkEntry "applications" "steam")
    (mkEntry "applications" "telegram-desktop")
    (mkEntry "applications" "vscode")
    (mkEntry "applications" "yazi")
    (mkEntry "applications" "zellij")
    (mkEntry "applications" "zsh")
    (mkEntry "core" "environment")
    (mkEntry "core" "ephemeralRootfs")
    (mkEntry "core" "etcOverlay")
    (mkEntry "core" "fhsCompatibility")
    (mkEntry "core" "initrd")
    (mkEntry "core" "localization")
    (mkEntry "core" "nix")
    (mkEntry "core" "userManagement")
    (mkEntry "core" "xdg")
    (mkEntry "desktop" "clipboard")
    (mkEntry "desktop" "desktopEssentials")
    (mkEntry "desktop" "environment-gnome")
    (mkEntry "desktop" "environment-niri")
    (mkEntry "desktop" "environment-wayfire")
    (mkEntry "desktop" "font")
    (mkEntry "desktop" "inputMethod")
    (mkEntry "desktop" "launcher")
    (mkEntry "desktop" "notification")
    (mkEntry "desktop" "screenLocker")
    (mkEntry "desktop" "taskbar")
    (mkEntry "desktop" "theme-gtk")
    (mkEntry "desktop" "theme-qt")
    (mkEntry "desktop" "wallpaper")
    (mkEntry "hardware" "bluetooth")
    (mkEntry "hardware" "graphicsDriver-intel")
    (mkEntry "hardware" "graphicsDriver-nvidia")
    (mkEntry "hardware" "keyMapper")
    (mkEntry "hardware" "networking")
    (mkEntry "hardware" "oom-killer")
    (mkEntry "hardware" "pipewire")
    (mkEntry "hardware" "scx-scheduler")
    (mkEntry "hardware" "tlp")
    (mkEntry "hardware" "wireless")
    (mkEntry "hardware" "zram-swap")
    (mkEntry "programs" "atuin")
    (mkEntry "programs" "bat")
    (mkEntry "programs" "colmena")
    (mkEntry "programs" "difftastic")
    (mkEntry "programs" "direnv")
    (mkEntry "programs" "eza")
    (mkEntry "programs" "fastfetch")
    (mkEntry "programs" "fd")
    (mkEntry "programs" "fzf")
    (mkEntry "programs" "glow")
    (mkEntry "programs" "nil")
    (mkEntry "programs" "nixpkgs-review")
    (mkEntry "programs" "ripgrep")
    (mkEntry "programs" "zoxide")
    (mkEntry "security" "fail2ban")
    (mkEntry "security" "password")
    (mkEntry "security" "secret")
    (mkEntry "security" "sudo")
    (mkEntry "services" "dconf")
    (mkEntry "services" "dnsproxy")
    (mkEntry "services" "gdm")
    (mkEntry "services" "ly")
    (mkEntry "services" "mpd-ecosystem")
    (mkEntry "services" "openssh")
    (mkEntry "services" "selector4nix")
    (mkEntry "services" "ssh-agent")
    (mkEntry "services" "tailscale")
    (mkEntry "services" "transparent-proxy")
    (mkEntry "virtualization" "container")
    (mkEntry "virtualization" "distrobox")
    (mkEntry "virtualization" "libvirt")
    (mkEntry "virtualization" "waydroid")
  ];
}
