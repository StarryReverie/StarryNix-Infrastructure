inputs:
(final: prev: {
  inherit (final.lixPackageSets.latest)
    nixpkgs-review
    nix-eval-jobs
    nix-fast-build
    ;

  colmena = (inputs.colmena.overlays.default final prev).colmena.override {
    nix-eval-jobs = final.lixPackageSets.latest.nix-eval-jobs;
  };

  nil = prev.nil.override {
    nix = final.lixPackageSets.latest.lix;
  };

  nix-direnv = prev.nix-direnv.override {
    nix = final.lixPackageSets.latest.lix;
  };

  ragenix = prev.nil.override {
    nix = final.lixPackageSets.latest.lix;
  };
})
