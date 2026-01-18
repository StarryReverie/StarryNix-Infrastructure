{
  config,
  inputs,
  withSystem,
  flakeRoot,
  ...
}:
let
  flakey-profile-lib = inputs.flakey-profile.lib;
  nixpkgs-lib = inputs.nixpkgs.lib;
in
let
  importProfile =
    entryPoint:
    let
      specialArgs = {
        inherit inputs flakeRoot;
      };
      baseProfileMeta = import entryPoint specialArgs;

      # It doesn't make sense that all users share one global profile. It should
      # only be used to pin channels and flake registry.
      baseProfileArgs = {
        pkgs = withSystem baseProfileMeta.system ({ pkgs, ... }: pkgs);
        pinned.nixpkgs = builtins.toString inputs.nixpkgs;
        paths = [ ];
      };
      rawBaseProfile = flakey-profile-lib.mkProfile baseProfileArgs;
      # Functionalities for switching and rollback are explicitly removed from
      # the global profile to prevent switching accidently.
      baseProfile = nixpkgs-lib.attrsets.removeAttrs rawBaseProfile [
        "switch"
        "rollback"
      ];

      profile = nixpkgs-lib.foldl (
        finalProfile: userEntry:
        nixpkgs-lib.recursiveUpdate finalProfile {
          users.${userEntry.name} = importApplyUserProfile userEntry.value specialArgs baseProfileArgs;
        }
      ) baseProfile (nixpkgs-lib.attrsets.attrsToList baseProfileMeta.users);
    in
    profile;

  importApplyUserProfile =
    topLevel: baseSpecialArgs: baseProfileArgs:
    let
      specialArgs = baseSpecialArgs // {
        inherit (baseProfileArgs) pkgs;
      };
      userProfileMeta = import topLevel specialArgs;

      userProfileArgs = baseProfileArgs // {
        inherit (userProfileMeta) paths;
      };
      rawUserProfile = flakey-profile-lib.mkProfile userProfileArgs;
      # Pinning channels and flake registry for a single user is potentially
      # problematic, so we remove the pinning scripts.
      # See <https://github.com/lf-/flakey-profile/issues/4>.
      userProfile = nixpkgs-lib.attrsets.removeAttrs rawUserProfile [
        "pins"
        "pin"
      ];
    in
    userProfile;
in
{
  flake.lib.profiles = {
    inherit importProfile;
  };
}
