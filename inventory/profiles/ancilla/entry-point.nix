{ inputs, ... }@specialArgs:
{
  system = "x86_64-linux";
  users = {
    starryreverie = ./starryreverie/top-level.nix;
  };
}
