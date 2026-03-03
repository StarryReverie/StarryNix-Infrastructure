{
  config,
  inputs,
  self,
  ...
}:
{
  flake.overlays = {
    lix = final: prev: {
      ragenix = prev.nil.override {
        nix = final.lixPackageSets.latest.lix;
      };
    };
  };
}
