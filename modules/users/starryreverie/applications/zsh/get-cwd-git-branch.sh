function get-cwd-git-branch() {
  CURRENT_BRANCH=$(git branch --show-current 2> /dev/null)

  if [[ $? -eq 0 ]]; then
    echo " ($CURRENT_BRANCH)"
  fi
}
