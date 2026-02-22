{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.root = {
    enable = true;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBHhBWBm0pl855WnAlKB6567DR3fzAWPYAbYI4YxmYFu starryreverie@superposition"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJFYQFEqRJVSW3kBXGRJ5QrgDYIPYl5mANwsXMmy26Ak starryreverie@DESKTOP-Q1328MM"
    ];
  };
}
