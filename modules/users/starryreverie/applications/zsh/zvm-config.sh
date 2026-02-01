typeset -g ZVM_MODE_RPROMPT=""
typeset -g ZVM_RPROMPT_ENABLED=1

function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  ZVM_HISTORY_KEYBINDING_SEARCH=
}

function zvm_h_to_insert_widget() {
  zvm_select_vi_mode $ZVM_MODE_INSERT
}

function zvm_shift_h_to_insert_widget() {
  zle beginning-of-line
  zvm_select_vi_mode $ZVM_MODE_INSERT
}

function zvm_after_lazy_keybindings() {
  zvm_define_widget zvm_h_to_insert_widget
  zvm_define_widget zvm_shift_h_to_insert_widget

  zvm_bindkey vicmd 'h' zvm_h_to_insert_widget
  zvm_bindkey vicmd 'i' up-line-or-history
  zvm_bindkey vicmd 'k' down-line-or-history
  zvm_bindkey vicmd 'j' backward-char
  zvm_bindkey vicmd 'l' forward-char
  zvm_bindkey vicmd 'H' zvm_shift_h_to_insert_widget
  zvm_bindkey vicmd 'J' vi-backward-word
  zvm_bindkey vicmd 'L' vi-forward-word-end
  zvm_bindkey vicmd 'gj' beginning-of-line
  zvm_bindkey vicmd 'gl' end-of-line
  zvm_bindkey vicmd 'U' redo

  zvm_bindkey visual 'v' zvm_exit_visual_mode
  zvm_bindkey visual 'i' vi-up-line
  zvm_bindkey visual 'k' vi-down-line
  zvm_bindkey visual 'j' vi-backward-char
  zvm_bindkey visual 'l' vi-forward-char
  zvm_bindkey visual 'J' vi-backward-word
  zvm_bindkey visual 'L' vi-forward-word-end

  zvm_bindkey viins '^[i' up-line
  zvm_bindkey viins '^[k' down-line
  zvm_bindkey viins '^[j' backward-char
  zvm_bindkey viins '^[l' forward-char
}

function zvm_custom_accept_line() {
  ZVM_RPROMPT_ENABLED=0
  RPROMPT=''
  zle reset-prompt
  zle .accept-line
}

function zvm_precmd_restore_rprompt() {
  ZVM_RPROMPT_ENABLED=1
  RPROMPT="${ZVM_MODE_RPROMPT}"
}

function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
      ZVM_MODE_RPROMPT="%(?..%?)%f %F{blue}NORMAL"
      ;;
    $ZVM_MODE_INSERT)
      ZVM_MODE_RPROMPT="%(?..%?)%f %F{green}INSERT"
      ;;
    $ZVM_MODE_VISUAL)
      ZVM_MODE_RPROMPT="%(?..%?)%f %F{magenta}VISUAL"
      ;;
    $ZVM_MODE_VISUAL_LINE)
      ZVM_MODE_RPROMPT="%(?..%?)%f %F{magenta}V-LINE"
      ;;
    $ZVM_MODE_REPLACE)
      ZVM_MODE_RPROMPT="%(?..%?)%f %F{yellow}REPLAC"
      ;;
  esac
  if [[ $ZVM_RPROMPT_ENABLED -eq 1 ]]; then
    RPROMPT="${ZVM_MODE_RPROMPT}"
  fi
}

function zvm_after_init() {
  zvm_after_select_vi_mode

  autoload -U add-zsh-hook
  add-zsh-hook precmd zvm_precmd_restore_rprompt

  zle -N zvm_custom_accept_line
  bindkey '^M' zvm_custom_accept_line
}
