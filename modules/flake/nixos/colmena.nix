{
  config,
  inputs,
  self,
  ...
}:
{
  flake.colmenaHive = inputs.colmena.lib.makeHive self.colmenaArg;

  flake.colmenaArg =
    let
      conf = self.nixosConfigurations;
    in
    (builtins.mapAttrs (name: value: { imports = value._module.args.modules; }) conf)
    // {
      # `meta.nixpkgs` is actually useless, but `lib` is needed for colmena
      meta.nixpkgs = { inherit (inputs.nixpkgs) lib; };
      meta.nodeNixpkgs = builtins.mapAttrs (name: value: value.pkgs) conf;
      meta.nodeSpecialArgs = builtins.mapAttrs (name: value: value._module.specialArgs) conf;
    };
}
