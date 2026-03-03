{
  config,
  inputs,
  self,
  ...
}:
{
  flake.overlays = {
    lix = final: prev: {
      nixpkgs-review = prev.nixpkgs-review.override {
        nix = final.lixPackageSets.latest.lix;
      };

      ragenix = prev.nil.override {
        nix = final.lixPackageSets.latest.lix;
      };
    };
  };
}
