# If this script is run as a systemd user service, then start Wayfire directly
if [ -n "${MANAGERPID:-}" ] && [ "${SYSTEMD_EXEC_PID:-}" = "$$" ]; then
  case "$(ps -p "$MANAGERPID" -o cmd=)" in
  *systemd*--user*)
    exec wayfire
    ;;
  esac
fi

# Use the shell configured for the current user
if [ -n "$SHELL" ] &&
   grep -q "$SHELL" /etc/shells &&
   ! (echo "$SHELL" | grep -q "false") &&
   ! (echo "$SHELL" | grep -q "nologin"); then
  if [ "$1" != '-l' ]; then
    exec bash -c "exec -l '$SHELL' -c '$0 -l $*'"
  else
    shift
  fi
fi

# Start Wayfire as a systemd user service
if systemctl --user -q is-active wayfire.service; then
  echo 'A Wayfire session is already running.'
  exit 1
fi
systemctl --user reset-failed

systemctl --user import-environment
if hash dbus-update-activation-environment 2>/dev/null; then
  dbus-update-activation-environment --all
fi

systemctl --user --wait start wayfire.service

systemctl --user start --job-mode=replace-irreversibly wayfire-shutdown.target
systemctl --user unset-environment WAYLAND_DISPLAY DISPLAY XAUTHORITY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP
