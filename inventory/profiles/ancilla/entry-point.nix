{ inputs, ... }@specialArgs:
let
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in
inputs.flakey-profile.lib.mkProfile {
  inherit pkgs;

  pinned = {
    nixpkgs = builtins.toString inputs.nixpkgs;
  };

  paths = with pkgs; [
    difftastic
    direnv
    helix
    htop
    lazygit
    zellij
    yazi-unwrapped
    nixfmt
    nixfmt-tree
  ];
}
