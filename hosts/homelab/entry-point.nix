{
  inputs,
  constants,
  flakeRoot,
  ...
}@specialArgs:
inputs.nixpkgs.lib.nixosSystem {
  inherit (constants) system;
  inherit specialArgs;

  modules = [
    # External modules
    inputs.nix-maid.nixosModules.default

    # StarryNix-Infrastructure
    (flakeRoot + /modules/nixos/starrynix-infrastructure/host)
    (flakeRoot + /nodes/registry.nix)

    # NixOS modules
    (flakeRoot + /modules/nixos/dae)
    (flakeRoot + /modules/nixos/nix)
    (flakeRoot + /modules/nixos/openssh)
    (flakeRoot + /modules/nixos/secret)
    ./hardware.nix
    ./networking.nix
    ./service.nix
    ./system.nix

    # Home modules (wrapper-manager + nix-maid)
    (
      { config, pkgs, ... }:
      {
        imports = [
          (flakeRoot + /modules/home/wrapper/system-options.nix)

          (flakeRoot + /modules/home/nix-maid/direnv)
          (flakeRoot + /modules/home/nix-maid/helix)
        ];

        wrapperConfigurations = {
          inherit pkgs;
          modules = [
            (flakeRoot + /modules/home/wrapper/wrapper-options.nix)
            { wrapperConfigurations.finalPackages = config.wrapperConfigurations.finalPackages; }

            (flakeRoot + /modules/home/wrapper/atuin)
            (flakeRoot + /modules/home/wrapper/bat)
            (flakeRoot + /modules/home/wrapper/difftastic)
            (flakeRoot + /modules/home/wrapper/direnv)
            (flakeRoot + /modules/home/wrapper/eza)
            (flakeRoot + /modules/home/wrapper/fastfetch)
            (flakeRoot + /modules/home/wrapper/fd)
            (flakeRoot + /modules/home/wrapper/fzf)
            (flakeRoot + /modules/home/wrapper/git)
            (flakeRoot + /modules/home/wrapper/helix)
            (flakeRoot + /modules/home/wrapper/lazygit)
            (flakeRoot + /modules/home/wrapper/ripgrep)
            (flakeRoot + /modules/home/wrapper/zellij)
            (flakeRoot + /modules/home/wrapper/zoxide)
            (flakeRoot + /modules/home/wrapper/zsh)
          ];
        };
      }
    )
  ];
}
