{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.helix.settings.editor = {
    line-number = "relative";
    completion-trigger-len = 1;
    bufferline = "always";
    idle-timeout = 0;
    color-modes = true;
    cursorline = true;
    true-color = true;
    text-width = 165;
    insert-final-newline = true;

    statusline = {
      left = [
        "mode"
        "spacer"
        "version-control"
        "file-name"
        "spinner"
        "diagnostics"
      ];

      right = [
        "position"
        "primary-selection-length"
        "selections"
        "total-line-numbers"
        "file-encoding"
        "file-line-ending"
        "file-type"
      ];

      mode = {
        normal = "NORMAL";
        insert = "INSERT";
        select = "SELECT";
      };
    };

    cursor-shape = {
      normal = "block";
      insert = "bar";
      select = "block";
    };

    indent-guides.render = true;

    lsp.display-messages = true;
  };
}
