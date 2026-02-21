{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.github-copilot-cli or { };
in
let
  copilotSandboxCore = pkgs.buildFHSEnvBubblewrap {
    name = "copilot-sandbox-core";

    targetPkgs =
      p: with p; [
        github-copilot-cli

        coreutils-full
        binutils
        findutils
        file
        procps
        gnutar
        gzip
        xz
        unzip
        jq
      ];

    runScript = "copilot";

    unshareUser = true;
    unshareIpc = true;
    unsharePid = true;
    unshareUts = true;
    unshareCgroup = true;
    dieWithParent = true;
    chdirToPwd = false;

    extraBwrapArgs = [
      "--bind"
      "$COPILOT_PERSISTENCE_DIR"
      "/persistence"

      "--bind"
      "$COPILOT_WORKSPACE_DIR"
      "/workspace"

      "--chdir"
      "/workspace"

      "--clearenv"

      "--setenv"
      "COLORTERM"
      "truecolor"

      "--setenv"
      "HOME"
      "/persistence"
    ];
  };

  copilotSandboxRunner = pkgs.writeShellScriptBin "copilot" ''
    set -euo pipefail

    usage() {
      cat <<'USAGE'
    Usage: copilot [OPTIONS] [-- ARGS...]

    Options:
      -p, --persistence <DIR>
              Set the directory for persistent state storage and mount it to `/persistence`
              in the sandbox. If omitted, `$XDG_STATE_HOME/github-copilot-cli` is used, thus
              anything will be destroyed after the session terminates.

      -w, --workspace <DIR>
              Set the workspace directory and mount it to `/workspace`. This is typically
              where you work in, so the CWD is also set to corresponding directory in the
              sandbox. If omitted, you'll be prompted whether to use current directory.

      -h, --help
              Show this help and exit.
    USAGE
    }

    p_provided=0
    w_provided=0
    PASS_THROUGH=()

    while [[ $# -gt 0 ]]; do
      case "$1" in
        -h|--help)
          usage
          exit 0
          ;;
        -p|--persistence)
          if [[ -n "''${2-}" && "''${2:0:1}" != "-" ]]; then
            COPILOT_PERSISTENCE_DIR="$2"
            p_provided=1
            shift 2
            continue
          else
            exit 2
          fi
          ;;
        -w|--workspace)
          if [[ -n "''${2-}" && "''${2:0:1}" != "-" ]]; then
            COPILOT_WORKSPACE_DIR="$2"
            w_provided=1
            shift 2
            continue
          else
            exit 2
          fi
          ;;
        --)
          shift
          PASS_THROUGH=("$@")
          break
          ;;
        -*)
          exit 2
          ;;
        *)
          PASS_THROUGH+=("$1")
          shift
          ;;
      esac
    done

    if [[ "$p_provided" -eq 0 ]]; then
      COPILOT_PERSISTENCE_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/github-copilot-cli"
    fi

    if [[ "$w_provided" -eq 0 ]]; then
      CWD="$(pwd)"
      if [[ -t 0 ]]; then
        read -r -p "No -w/--workspace provided. Use current directory as workspace? [Y/n] " reply
        reply="''${reply:-Y}"
        case "$reply" in
          [Yy]* )
            COPILOT_WORKSPACE_DIR="$CWD"
            ;;
          [Nn]* )
            while true; do
              read -r -p "Enter workspace directory path: " tmpdir
              if [[ -n "''${tmpdir-}" ]]; then
                COPILOT_WORKSPACE_DIR="$tmpdir"
                break
              fi
            done
            ;;
          * )
            COPILOT_WORKSPACE_DIR="$CWD"
            ;;
        esac
      else
        COPILOT_WORKSPACE_DIR="$CWD"
      fi
    fi

    expand_path() {
      local path="$1"
      if [[ "$path" == ~* ]]; then
        eval "path=$path"
      fi
      if [[ "$path" != /* ]]; then
        path="$(pwd)/$path"
      fi
      printf '%s' "$path"
    }

    export COPILOT_PERSISTENCE_DIR="$(expand_path "$COPILOT_PERSISTENCE_DIR")"
    export COPILOT_WORKSPACE_DIR="$(expand_path "$COPILOT_WORKSPACE_DIR")"

    mkdir -p "$COPILOT_PERSISTENCE_DIR"
    mkdir -p "$COPILOT_WORKSPACE_DIR"

    exec "${lib.getExe copilotSandboxCore}" "''${PASS_THROUGH[@]}"
  '';
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = [ copilotSandboxRunner ];
    };

    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".local/state/github-copilot-cli" ];
      };
    };
  };
}
