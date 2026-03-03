{
  config,
  inputs,
  self,
  ...
}:
{
  flake.overlays = {
    lix = final: prev: {
      nix-direnv = prev.nix-direnv.override {
        nix = final.lixPackageSets.latest.lix;
      };

      nixpkgs-review = prev.nixpkgs-review.override {
        nix = final.lixPackageSets.latest.lix;
      };

      ragenix = prev.nil.override {
        nix = final.lixPackageSets.latest.lix;
      };
    };
  };
}
