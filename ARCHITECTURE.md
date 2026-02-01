# StarryNix-Infrastructure Architecture

## Overview

### Design

This project tries to conform the design philosophy below:

- Prefer simpler solution
    - Use enable options instead of conditional imports to tweak features for each host.
        - The conditional imports method seems simple at first, but it doesn't scale well when cross-referencing are largely involved.
    - Duplication is preferred over the DRY principle if the resulting code is less and more concise.
    - Make abstraction only if there is a true need for polymorphism and changeable configurations.
- Prioritize maintainability
    - Write easy-to-read code and configurations.
        - Make use of `let ... in ...` expressions and variable binding to explicitly assign meaning to variables.
        - Add examples to self-defined NixOS options.
    - Avoid Nixpkgs Overlays to eliminate implicit control-flows and unexpected overrides.
    - Add assertions to NixOS modules to ensure custom invarants.
    - Centralize related configurations and separate orthogonal configurations.

### Repository Structure

- `inventory`: Configuration inventory for hosts, nodes, and profiles.
    - `hosts`: Configurations of all hosts running NixOS or NixOS-like system.
        - `interference`: VPS configurations.
        - `superposition`: Main workstation for everyday life.
        - `topological`: Main self-hosted server and hypervisor for `microvm.nix` nodes.
    - `nodes`: Configurations of all `microvm.nix` nodes grouped as clusters.
        - `jellyfin`: Jellyfin streaming media service cluster.
            - `main`: Main node of the Jellyfin service.
        - `nextcloud`: Nextcloud storage service cluster.
            - `main`: Web UI & database of Nextcloud's states.
            - `storage`: S3-compatible object storage backend.
            - `cache`: Redis-based caching service.
        - `searxng`: SearXNG meta-search engine.
            - `main`: Main node of the SearXNG service.
        - `jupyter`: Jupyter Lab.
            - `main`: Main node of Jupyter Lab.
        - `dns`: DNS server
            - `main`: The entry point of DNS service, with ad-filtering support.
            - `recursive`: DNS caching server using Unbound.
        - `registry.nix`: Node manifest and core metadata management.
    - `profiles`: Package-only environment based on `flakey-profile` for various system.
- `modules`: Reusable modules of various scopes.
    - `flake`: Flake-specific modules and utilities based on `flake-parts` framework.
        - `lib`: Reusable Nix function library.
        - `dev-environment`: Development environment configurations.
        - `nixos`: Entry points of NixOS configurations.
        - `overlays`: Nixpkgs overlays for custom package modifications.
        - `packages`: Nixpkgs configurations and custom package definitions.
        - `profiles`: Entry points of profile configurations.
    - `system`: System-wide NixOS modules organized by domains.
        - `starrynix-infrastructure`: Core modules of StarryNix-Infrastructure.
        - `applications`: High-level pplication configurations.
        - `core`: Core system configuration modules.
        - `desktop`: Desktop environment and graphical interface modules.
        - `hardware`: Hardware-specific configurations and drivers.
        - `programs`: Low-level programs and utilities configurations.
        - `security`: Security hardening and access control modules.
        - `services`: Service configurations.
        - `virtualization`: Virtualization and containerization modules.
    - `users`: User-specific NixOS modules, mirrored `system` and grouped by user name.
        - `common`: Common modules that can be used by each user.
        - `starryreverie`: User-specific configurations for starryreverie.
- `secrets`: Secret management of the infrastructure.
    - `identities`: Encrypted identities of secrets.
    - `rekeyed`: Re-encrypeted secrets for each machines.
    - `*.age`: secrets.

## Services

### Abstractions

StarryNix-Infrastructure exposes a compact NixOS option declaration to describe hosts, clusters, and nodes:

- [Registry Options](./modules/system/starrynix-infrastructure/registry/default.nix) `starrynix-infrastructure.registry.*`: the central source of each node's metadata
    - Unique identifier and index for each node.
    - Deterministic MACs, NICs and IPv4 addresses allocation.
    - Additional metadata declaration, such as SSH keys.
    - Consumed by both node and host modules.
- [Node Options](./modules/system/starrynix-infrastructure/node/default.nix) `starrynix-infrastructure.node.*`: node specific settings
    - Declares hypervisor choices, VSOCK CID, virtiofs shares and state directory setup.
    - Configures the network in node side.
    - Sets up node secret management (`agenix` & `agenix-rekey`).
    - Applies security defaults.
    - Mounts node's SSH host key files from the host.
- [Host Options](./modules/system/starrynix-infrastructure/host/default.nix) `starrynix-infrastructure.host.*`: host-level deployment and node orchestration.
    - Declares VM `nodeConfigurations` and which clusters the host serves.
    - Generates cluster networks and port forwarding configurations.
    - Provides nodes with SSH keys access.

These abstractions hide raw `microvm.nix` and NixOS options from `nixpkgs` behind a consistent declarative surface.

### Configurations

- Central Metadata
    - All core cluster and node metadata is defined once in the [registry definition](./inventory/nodes/registry.nix), validated and enriched by the `starrynix-infrastructure.registry.*`.
    - The registry assigns cluster/node indexes, derives deterministic MACs and IPv4s, names bridges and NICs, and carries SSH key mount metadata. Both nodes and hosts read these read-only values.

    ```nix
    # inventory/nodes/registry.nix
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
    - Nodes live under the `inventory/nodes` directory and are grouped as clusters. Each node provides `entry-point.nix` (for example the [entry point](./inventory/nodes/nextcloud/main/entry-point.nix) for the Nextcloud Web UI).
    - Entry points call [`lib.makeNodeEntryPoint`](./modules/flake/lib/default.nix) and import the shared node module plus the registry, producing a runnable NixOS configuration.

    ```nix
    # inventory/nodes/nextcloud/main/entry-point.nix
    { inputs, flakeRoot, ... }@specialArgs:
    inputs.self.lib.makeNodeEntryPoint inputs.nixpkgs.lib specialArgs {
      modules = [
        (flakeRoot + /modules/system/starrynix-infrastructure/node)
        (flakeRoot + /inventory/nodes/registry.nix)
        ./service.nix
        ./system.nix
      ];
    }
    ```

- Nodes & Hosts
    - Nodes describe only node behavior and identity via `starrynix-infrastructure.node.*`. They do not depend on a specific host.
    - Hosts assemble infrastructure via `starrynix-infrastructure.host.*`, which select a subset of clusters with `deployment.enabledClusters`, and acquire all `nodeConfigurations` from the flake outputs.

    ```nix
    # inventory/hosts/topological/system/service.nix
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
    # inventory/hosts/topological/system/service.nix
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
