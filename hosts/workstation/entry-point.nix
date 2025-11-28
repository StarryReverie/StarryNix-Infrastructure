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
    (flakeRoot + /modules/nixos/dae)
    (flakeRoot + /modules/nixos/firefox)
    (flakeRoot + /modules/nixos/font)
    (flakeRoot + /modules/nixos/networking)
    (flakeRoot + /modules/nixos/nix)
    (flakeRoot + /modules/nixos/openssh)
    (flakeRoot + /modules/nixos/secret)
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

          (flakeRoot + /modules/home/nix-maid/clipboard)
          (flakeRoot + /modules/home/nix-maid/direnv)
          (flakeRoot + /modules/home/nix-maid/environment)
          (flakeRoot + /modules/home/nix-maid/gtk)
          (flakeRoot + /modules/home/nix-maid/helix)
          (flakeRoot + /modules/home/nix-maid/hyprlock)
          (flakeRoot + /modules/home/nix-maid/niri)
          (flakeRoot + /modules/home/nix-maid/qt)
          (flakeRoot + /modules/home/nix-maid/xdg)
          ./home/nix-maid/kanshi.nix
          ./home/nix-maid/niri.nix
        ];

        wrapping = {
          inherit pkgs;
          modules = [
            (flakeRoot + /modules/home/wrapper/alacritty)
            (flakeRoot + /modules/home/wrapper/atuin)
            (flakeRoot + /modules/home/wrapper/bat)
            (flakeRoot + /modules/home/wrapper/difftastic)
            (flakeRoot + /modules/home/wrapper/direnv)
            (flakeRoot + /modules/home/wrapper/eza)
            (flakeRoot + /modules/home/wrapper/fastfetch)
            (flakeRoot + /modules/home/wrapper/fd)
            (flakeRoot + /modules/home/wrapper/fzf)
            (flakeRoot + /modules/home/wrapper/git)
            (flakeRoot + /modules/home/wrapper/lazygit)
            (flakeRoot + /modules/home/wrapper/mako)
            (flakeRoot + /modules/home/wrapper/ripgrep)
            (flakeRoot + /modules/home/wrapper/rofi)
            (flakeRoot + /modules/home/wrapper/waybar)
            (flakeRoot + /modules/home/wrapper/yazi)
            (flakeRoot + /modules/home/wrapper/zellij)
            (flakeRoot + /modules/home/wrapper/zoxide)
            (flakeRoot + /modules/home/wrapper/zsh)
          ];
        };
      }
    )
  ];
}
