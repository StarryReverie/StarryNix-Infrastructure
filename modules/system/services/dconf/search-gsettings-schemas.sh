set -euo pipefail

XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

DIRS=(@gsettingsSchemaRoots@)

get_leaf_directories() {
  local root_dir="$1"
  if [[ ! -d "$root_dir" ]]; then
    return
  fi

  # Use find to get all directories, then use awk to identify leaf directories
  find -L "$root_dir" -type d -print0 | awk -v RS='\0' '
  BEGIN {
    count = 0
  }
  {
    dirs[count] = $0
    len = length($0)
    lens[count] = len
    count++
  }
  END {
    # Identify leaves by checking if each directory is a prefix of any other
    for (i = 0; i < count; i++) {
    is_leaf = 1
    current_dir = dirs[i]
    current_len = lens[i]

    # Compare with all other directories
    for (j = 0; j < count; j++) {
      if (i != j) {
        # Check if dirs[j] starts with current_dir + "/"
        # This means current_dir is a parent of dirs[j]
        temp_dir = current_dir "/"
        if (substr(dirs[j], 1, length(temp_dir)) == temp_dir) {
        is_leaf = 0
        break
        }
      }
    }

    if (is_leaf) {
      print current_dir
    }
    }
  }'
}

# Collect all leaf directories from all root dirs
all_leaves=()
for dir in "${DIRS[@]}"; do
  # Handle potential glob expansion
  eval "expanded_dirs=($dir)"

  for expanded_dir in "${expanded_dirs[@]}"; do
    if [[ -d "$expanded_dir" ]]; then
    while IFS= read -r leaf_dir; do
      all_leaves+=("$leaf_dir")
    done < <(get_leaf_directories "$expanded_dir")
    fi
  done
done

# Join the array elements with colons
if (( ${#all_leaves[@]} > 0 )); then
  (IFS=':'; echo "${all_leaves[*]}")
else
  echo ""
fi
