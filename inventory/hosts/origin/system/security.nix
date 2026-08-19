{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    # Secrets
    {
      systemd.services.decrypt-ssh-host-private-key = {
        description = "Decrypt the pre-generated SSH host key";

        script = ''
          umask 077
          mkdir -p /nix/persistence/etc/ssh

          cp ${./keys/ed25519.pub} /nix/persistence/etc/ssh/ssh_host_ed25519_key.pub
          chmod 0644 /nix/persistence/etc/ssh/ssh_host_ed25519_key.pub

          for n in 3 2 1; do
            rm -f /nix/persistence/etc/ssh/ssh_host_ed25519_key
            passphrase="$(${config.systemd.package}/bin/systemd-ask-password \
              "Type passphrase to decrypt the SSH host private key ($n attempt(s) left)")"

            # `age` doesn't allow reading passphrase from anything but a real tty. Use `script` to
            # create a pty to trick `age` to read passphrase from the actually piped input.
            if printf '%s\n' "$passphrase" | ${pkgs.util-linux}/bin/script -qec \
              "${pkgs.age}/bin/age -d -o /nix/persistence/etc/ssh/ssh_host_ed25519_key ${./keys/ed25519.age}" /dev/null; then
              chmod 0600 /nix/persistence/etc/ssh/ssh_host_ed25519_key
              exit 0
            fi

            echo "Invalid passphrase"
          done

          echo "Decrypt SSH host private key failed"
          exit 1
        '';

        wantedBy = [ "sysinit.target" ];

        unitConfig = {
          Before = [
            "sysinit.target"
            "vaultix-activate.service"
            "sshd-keygen.service"
            "sshd.service"
          ];
          DefaultDependencies = "no";
        };

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          TimeoutStartSec = "60s";
        };
      };
    }
  ];
}
