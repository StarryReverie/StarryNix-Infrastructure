{
  config,
  inputs,
  self,
  ...
}:
{
  flake.overlays = {
    lix = final: prev: {
      ragenix = prev.ragenix.override {
        nix = final.lixPackageSets.latest.lix;
      };
    };
  };
}
