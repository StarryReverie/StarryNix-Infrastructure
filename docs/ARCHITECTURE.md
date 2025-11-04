# StarryNix-Infrastructure Architecture

## Overview

### Design

This project tries to conform the design philosophy below:

- Prefer simpler solution
    - Conventional NixOS modules design principles may not be as necessary as in Nixpkgs.
        - Try to replace `*.enable` with simpler (un)commenting `imports = [ ... ]`, if applicable.
    - Duplication is preferred over the DRY principle if the resulting code is less and more concise. 
    - Make abstraction only if there is a true need for polymorphism and changeable configurations.
- Prioritize maintainability
    - Write easy-to-read code and configurations.
        - Make use of `let ... in ...` expressions and variable binding to explicitly assign meaning to variables.
        - Add examples to self-definied NixOS options.
    - Avoid Nixpkgs Overlays to eliminate implicit control-flows and unexpected overrides.
    - Add assertions to NixOS modules to ensure custom invarants.
    - Centralize related configurations and separate orthogonal configurations.

### Repository Structure

- `docs`: Documentations.
- `hosts`: Configurations of all hosts running NixOS or NixOS-like system.
    - `homelab`: Main server and hypervisor for `microvm.nix` nodes.
- `lib`: Reusable Nix function library.
- `modules`: Common modules.
    - `home`: Modules used by Home Manager.
    - `nixos`: NixOS modules.
        - `starrynix-infrastructure`: Core modules of StarryNix-Infrastructure.
- `nodes`: Configurations of all `microvm.nix` nodes grouped as clusters.
    - `jellyfin`: Jellyfin streaming media service cluster.
        - `main`: Main node of the Jellyfin service.
    - `nextcloud`: Nextcloud storage service cluster.
        - `main`: Web UI & database of Nextcloud's states.
        - `storage`: S3-compatible object storage backend.
        - `cache`: Redis-based caching service.
    - `searxng`: SearXNG meta-search engine.
        - `main`: Main node of the SearXNG service.
    - `registry.nix`: Node manifest and core metadata management.
- `secrets`: Secret management of the infrastructure.
    - `identities`: Encrypted identities of secrets.
    - `rekeyed`: Re-encrypeted secrets for each machines.
    - `*.age`: secrets.

## Services

### Abstractions

StarryNix-Infrastructure exposes a compact NixOS option declaration to describe hosts, clusters, and nodes:

- [Registry Options](../modules/nixos/starrynix-infrastructure/registry/default.nix) `starrynix-infrastructure.registry.*`: the central source of each node's metadata
    - Unique identifier and index for each node.
    - Deterministic MACs, NICs and IPv4 addresses allocation.
    - Additional metadata declaration, such as SSH keys.
    - Consumed by both node and host modules.
- [Node Options](../modules/nixos/starrynix-infrastructure/node/default.nix) `starrynix-infrastructure.node.*`: node specific settings
    - Declares hypervisor choices, VSOCK CID, virtiofs shares and state directory setup.
    - Configures the network in node side.
    - Sets up node secret management (`agenix` & `agenix-rekey`).
    - Applies security defaults.
    - Mounts node's SSH host key files from the host.
- [Host Options](../modules/nixos/starrynix-infrastructure/host/default.nix) `starrynix-infrastructure.host.*`: host-level deployment and node orchestration.
    - Declares VM `nodeConfigurations` and which clusters the host serves.
    - Generates cluster networks and port forwarding configurations.
    - Provides nodes with SSH keys access.

These abstractions hide raw `microvm.nix` and NixOS options from `nixpkgs` behind a consistent declarative surface.

### Configurations

- Central Metadata
    - All core cluster and node metadata is defined once in the [registry definition](../nodes/registry.nix), validated and enriched by the `starrynix-infrastructure.registry.*`.
    - The registry assigns cluster/node indexes, derives deterministic MACs and IPv4s, names bridges and NICs, and carries SSH key mount metadata. Both nodes and hosts read these read-only values.

    ```nix
    # nodes/registry.nix
    starrynix-infrastructure.registry.clusters = {
      "nextcloud" = {
        index = 2;
        nodes."main".index = 1;
        nodes."storage".index = 2;
        nodes."cache".index = 3;
      };
      # ...
    };

    starrynix-infrastructure.registry.secret = {
      masterIdentities = [
        {
          identity = flakeRoot + /secrets/identities/main.key.age;
          pubkey = "age1ke6r2945sh89e6kax2myzahaedwk7647wq4kjn7luwgqg4rgduhsyggmxm";
        }
      ];
      localStorageDir = flakeRoot + /secrets/rekeyed/nodes;
    };
    ```

- Node Definition
    - Nodes live under the `nodes` directory and are grouped as clusters. Each node provides `entry-point.nix` (for example the [entry point](../nodes/nextcloud/main/entry-point.nix) for the Nextcloud Web UI).
    - Entry points call [`lib.makeNodeEntryPoint`](../lib/default.nix) and import the shared node module plus the registry, producing a runnable NixOS configuration.

    ```nix
    # nodes/nextcloud/main/entry-point.nix
    { inputs, flakeRoot, ... }@specialArgs:
    inputs.self.lib.makeNodeEntryPoint inputs.nixpkgs.lib specialArgs {
      modules = [
        (flakeRoot + /modules/nixos/starrynix-infrastructure/node)
        (flakeRoot + /nodes/registry.nix)
        ./service.nix
        ./system.nix
      ];
    }
    ```

- Nodes & Hosts
    - Nodes describe only node behavior and identity via `starrynix-infrastructure.node.*`. They do not depend on a specific host.
    - Hosts assemble infrastructure via `starrynix-infrastructure.host.*`, which select a subset of clusters with `deployment.enabledClusters`, and acquire all `nodeConfigurations` from the flake outputs.

    ```nix
    # hosts/homelab/service.nix
    starrynix-infrastructure.host = {
      deployment = {
        inherit (inputs.self) nodeConfigurations;
        enabledClusters = [
          "nextcloud"
          # ...
        ];
      };
    };
    ```

- Port Forwarding
    - Hosts define forwarding rules in `host.networking.forwardPorts`.
    - `starrynix-infrastructure.host.*` translates rules into bridges, NAT, and nftables DNAT/SNAT, resolving destination IPv4s from the registry.

    ```nix
    # hosts/homelab/service.nix
    starrynix-infrastructure.host.networking.forwardPorts = [
      {
        protocol = "tcp";
        sourcePort = 8081;
        toCluster = "nextcloud";
        toNode = "main";
        destinationPort = 80;
      }
      # ...
    ];
    ```
