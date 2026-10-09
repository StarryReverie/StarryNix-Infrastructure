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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGfMp8TSE9+MYV4dPMxt9fDzA+gvowO7BkFimhpJ1k5I starryreverie@entanglement"
    ];
  };
}
