{ inputs, ... }@specialArgs:
let
  lib = inputs.nixpkgs.lib;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

  # It doesn't make sense that all users share one global profile. It should
  # only be used to pin channels and flake registry.
  baseProfileArgs = {
    inherit pkgs;

    pinned = {
      nixpkgs = builtins.toString inputs.nixpkgs;
    };

    paths = [ ];
  };

  rawBaseProfile = inputs.flakey-profile.lib.mkProfile baseProfileArgs;

  # Functionalities for switching and rollback are explicitly removed from the
  # global profile to prevent switching accidently.
  baseProfile = lib.attrsets.removeAttrs rawBaseProfile [
    "switch"
    "rollback"
  ];

  importApplyUserProfile =
    baseProfileArgs: topLevel:
    let
      userProfileArgs = baseProfileArgs // {
        paths =
          (import topLevel {
            inherit inputs;
            inherit (baseProfileArgs) pkgs;
          }).paths;
      };

      rawUserProfile = inputs.flakey-profile.lib.mkProfile userProfileArgs;

      # Pinning channels and flake registry for a single user is potentially
      # problematic, so we remove the pinning scripts.
      # See <https://github.com/lf-/flakey-profile/issues/4>.
      userProfile = lib.attrsets.removeAttrs rawUserProfile [
        "pins"
        "pin"
      ];
    in
    userProfile;
in
lib.pipe baseProfile [
  (lib.flip lib.attrsets.recursiveUpdate {
    users.starryreverie = importApplyUserProfile baseProfileArgs ./starryreverie/top-level.nix;
  })
]
