{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.helix.settings.keys = {
    normal = {
      h = "insert_mode";
      j = "move_char_left";
      J = "move_prev_word_start";
      k = "move_line_down";
      i = "move_line_up";
      H = "insert_at_line_start";
      L = "move_next_word_end";
      K = lib.replicate 5 "move_line_down";
      I = lib.replicate 5 "move_line_up";
      W = ":write";
      E = ":quit";
      x = "@miw";
      X = "extend_line_below";
      # Workaround for using C-A-i in zellij
      A-tab = [
        "extend_to_line_bounds"
        "delete_selection"
        "move_line_up"
        "paste_before"
      ];
      C-A-i = [
        "extend_to_line_bounds"
        "delete_selection"
        "move_line_up"
        "paste_before"
      ];
      C-A-k = [
        "extend_to_line_bounds"
        "delete_selection"
        "paste_after"
      ];
      A-i = "expand_selection";
      A-k = "shrink_selection";
      A-j = "select_prev_sibling";
      A-l = "select_next_sibling";
      A-o = "no_op";
      A-p = "no_op";
      A-n = "no_op";

      z = {
        k = "scroll_down";
        i = "scroll_up";
      };

      w = {
        w = "rotate_view";
        j = "jump_view_left";
        k = "jump_view_down";
        l = "jump_view_right";
        i = "jump_view_up";
        J = [
          "vsplit"
          "swap_view_left"
        ];
        K = "hsplit";
        L = "vsplit";
        I = [
          "hsplit"
          "swap_view_up"
        ];
        n = ":new";
        e = ":buffer-close";
      };

      g = {
        j = "goto_first_nonwhitespace";
        k = "move_line_down";
        i = "move_line_up";
        l = "goto_line_end";
        h = "goto_line_start";
        s = "no_op";
      };

      Z = {
        k = "scroll_down";
        K = lib.replicate 5 "scroll_down";
        i = "scroll_up";
        I = lib.replicate 5 "scroll_up";
        j = "no_op";
      };
    };

    insert = {
      A-i = "move_line_up";
      A-I = lib.replicate 5 "move_line_up";
      A-k = "move_line_down";
      A-K = lib.replicate 5 "move_line_down";
      A-j = "move_char_left";
      A-J = "move_prev_word_start";
      A-l = "move_char_right";
      A-L = [
        "move_next_word_end"
        "move_char_right"
      ];
    };

    select = {
      h = "insert_mode";
      j = "extend_char_left";
      J = "extend_prev_word_start";
      k = "extend_line_down";
      i = "extend_line_up";
      H = "insert_at_line_start";
      L = "extend_next_word_end";
      K = lib.replicate 5 "extend_line_down";
      I = lib.replicate 5 "extend_line_up";
      W = ":write";
      E = ":quit";
      x = [
        "move_prev_word_end"
        "move_next_word_start"
        "trim_selections"
      ];
      X = "extend_line_below";
      A-i = "expand_selection";
      A-k = "shrink_selection";
      A-j = "select_prev_sibling";
      A-l = "select_next_sibling";
      A-o = "no_op";
      A-p = "no_op";
      A-n = "no_op";

      z = {
        k = "scroll_down";
        i = "scroll_up";
      };

      w = {
        w = "rotate_view";
        j = "jump_view_left";
        k = "jump_view_down";
        l = "jump_view_right";
        i = "jump_view_up";
        J = [
          "vsplit"
          "swap_view_left"
        ];
        K = "hsplit";
        L = "vsplit";
        I = [
          "hsplit"
          "swap_view_up"
        ];
        n = ":new";
        e = ":buffer-close";
      };

      g = {
        j = "goto_first_nonwhitespace";
        k = "extend_line_down";
        i = "extend_line_up";
        l = "goto_line_end";
        h = "goto_line_start";
      };

      Z = {
        k = "scroll_down";
        K = lib.replicate 5 "scroll_down";
        i = "scroll_up";
        I = lib.replicate 5 "scroll_up";
        j = "no_op";
      };
    };
  };
}
