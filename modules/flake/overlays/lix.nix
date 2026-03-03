{
  config,
  inputs,
  self,
  ...
}:
{
  flake.overlays = {
    lix = final: prev: {
      colmena = (inputs.colmena.overlays.default final prev).colmena.override {
        nix-eval-jobs = final.lixPackageSets.latest.nix-eval-jobs;
      };

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
