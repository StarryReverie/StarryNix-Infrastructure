{
  inputs,
  constants,
  flakeRoot,
  ...
}@specialArgs:
inputs.nixpkgs.lib.nixosSystem {
  inherit (constants) system;
  inherit specialArgs;

  extraModules = [
    inputs.colmena.nixosModules.deploymentOptions
  ];

  modules = [
    # External modules
    inputs.agenix-rekey.nixosModules.default
    inputs.agenix.nixosModules.default
    inputs.nix-maid.nixosModules.default

    # Colmena
    {
      deployment.allowLocalDeployment = true;
      deployment.targetHost = null;
      deployment.tags = [ "workstation" ];
    }

    # NixOS modules
    (flakeRoot + /modules/nixos/bluetooth)
    (flakeRoot + /modules/nixos/container)
    (flakeRoot + /modules/nixos/dae)
    (flakeRoot + /modules/nixos/distrobox)
    (flakeRoot + /modules/nixos/fcitx5)
    (flakeRoot + /modules/nixos/firefox)
    (flakeRoot + /modules/nixos/font)
    (flakeRoot + /modules/nixos/networking)
    (flakeRoot + /modules/nixos/nix)
    (flakeRoot + /modules/nixos/pipewire)
    (flakeRoot + /modules/nixos/openssh)
    (flakeRoot + /modules/nixos/secret)
    (flakeRoot + /modules/nixos/waydroid)
    (flakeRoot + /modules/nixos/wireless)
    ./nixos/desktop.nix
    ./nixos/hardware.nix
    ./nixos/networking.nix
    ./nixos/system.nix

    # Home modules (wrapper-manager + nix-maid)
    (
      { config, pkgs, ... }:
      {
        imports = [
          (flakeRoot + /modules/home/wrapper/system-options.nix)

          (flakeRoot + /modules/home/nix-maid/alacritty)
          (flakeRoot + /modules/home/nix-maid/atuin)
          (flakeRoot + /modules/home/nix-maid/bat)
          (flakeRoot + /modules/home/nix-maid/clipboard)
          (flakeRoot + /modules/home/nix-maid/direnv)
          (flakeRoot + /modules/home/nix-maid/environment)
          (flakeRoot + /modules/home/nix-maid/fd)
          (flakeRoot + /modules/home/nix-maid/github-copilot-cli)
          (flakeRoot + /modules/home/nix-maid/gtk-theme)
          (flakeRoot + /modules/home/nix-maid/helix)
          (flakeRoot + /modules/home/nix-maid/hyprlock)
          (flakeRoot + /modules/home/nix-maid/lazygit)
          (flakeRoot + /modules/home/nix-maid/niri-environment)
          (flakeRoot + /modules/home/nix-maid/qt-theme)
          (flakeRoot + /modules/home/nix-maid/rofi)
          (flakeRoot + /modules/home/nix-maid/swaync)
          (flakeRoot + /modules/home/nix-maid/vscode)
          (flakeRoot + /modules/home/nix-maid/waybar)
          (flakeRoot + /modules/home/nix-maid/wpaperd)
          (flakeRoot + /modules/home/nix-maid/xdg)
          (flakeRoot + /modules/home/nix-maid/yazi)
          (flakeRoot + /modules/home/nix-maid/zellij)
          (flakeRoot + /modules/home/nix-maid/zoxide)
          (flakeRoot + /modules/home/nix-maid/zsh)
          ./home/nix-maid/kanshi.nix
          ./home/nix-maid/niri-environment.nix
        ];

        wrapping = {
          inherit pkgs specialArgs;
          modules = [
            (flakeRoot + /modules/home/wrapper/difftastic)
            (flakeRoot + /modules/home/wrapper/direnv)
            (flakeRoot + /modules/home/wrapper/eza)
            (flakeRoot + /modules/home/wrapper/fastfetch)
            (flakeRoot + /modules/home/wrapper/fzf)
            (flakeRoot + /modules/home/wrapper/git)
            (flakeRoot + /modules/home/wrapper/ripgrep)
            (flakeRoot + /modules/home/wrapper/zsh)
          ];
        };
      }
    )
  ];
}
