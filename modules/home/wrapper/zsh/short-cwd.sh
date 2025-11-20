: ${PWD_SHORT_KEEP:=1}

short-cwd() {
  local keep=${PWD_SHORT_KEEP}
  local p="$PWD"

  if [[ -n $HOME && $p = $HOME* ]]; then
    if [[ $p == "$HOME" ]]; then
      print -n "~"
      return
    fi
    p="~${p#$HOME}"
  fi

  local prefix=""
  if [[ $p = /* ]]; then
    prefix="/"
    p=${p#/}
  fi

  local -a parts
  if [[ -z $p ]]; then
    parts=()
  else
    parts=(${(s:/:)p})
  fi
  local n=${#parts}

  if (( n <= keep )); then
    if (( n == 0 )); then
      print -n "${prefix:-/}"
    else
      if [[ -n $prefix ]]; then
        print -n "$prefix${(j:/:)parts}"
      else
        print -n "${(j:/:)parts}"
      fi
    fi
    return
  fi

  local -a out
  local i
  local upto=$(( n - keep ))

  for (( i = 1; i <= upto; i++ )); do
    local seg=${parts[i]}
    if [[ $seg == "~" ]]; then
      out+=("~")
      continue
    fi
    if [[ -z $seg ]]; then
      out+=("")
      continue
    fi
    if [[ $seg = .* && ${#seg} -gt 1 ]]; then
      out+=(".${seg:1:1}")
    else
      out+=("${seg:0:1}")
    fi
  done

  for (( ; i <= n; i++ )); do
    out+=("${parts[i]}")
  done

  local result="${(j:/:)out}"
  if [[ -n $prefix ]]; then result="/$result"; fi
  print -n -- "$result"
}
