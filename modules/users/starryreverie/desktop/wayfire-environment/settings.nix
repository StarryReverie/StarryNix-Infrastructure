{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.desktop.wayfire-environment or { };
in
{
  config = {
    custom.users.starryreverie = {
      desktop.wayfire-environment = {
        settings = lib.mkIf (customCfg.enable or false) {
          core = {
            close_top_view = "<super> KEY_X";
            exit = "<super> <ctrl> <shift> KEY_ESC";
            preferred_decoration_mode = "server";
            vheight = 1;
            vwidth = 8;
            plugins = lib.strings.concatStringsSep " " [
              "alpha"
              "animate"
              "blur"
              "autostart"
              "command"
              "cube"
              "expo"
              "grid"
              "input-method-v1"
              "move"
              "resize"
              "switcher"
              "vswitch"
              "window-rules"
              "wobbly"
            ];
            xwayland = true;
          };

          command = {
            binding_terminal = "<super> KEY_Q";
            command_terminal = "alacritty";

            binding_launcher = "<super> KEY_SPACE";
            command_launcher = "rofi -show drun";
          };

          input = {
            mouse_accel_profile = "flat";
            natural_scroll = true;
            kb_repeat_delay = 200;
          };

          input-method-v1 = {
            enable_text_input_v1 = true;
            enable_text_input_v3 = true;
          };

          workarounds = {
            use_external_output_configuration = true;
          };

          cube = {
            activate = "<super> <shift> BTN_LEFT";
            rotate_left = "<super> KEY_J";
            rotate_right = "<super> KEY_L";
            zoom = 0.7;
          };

          expo = {
            toggle = "<super> KEY_TAB";
          };

          move = {
            activate = "<super> BTN_LEFT";
          };

          resize = {
            activate = "<super> BTN_RIGHT";
          };

          switcher = {
            next_view = "<alt> KEY_TAB";
            prev_view = "<alt> <shift> KEY_TAB";
          };

          vswitch = {
            send_win_left = "<super> <ctrl> KEY_J";
            send_win_right = "<super> <ctrl> KEY_L";
          };
        };
      };
    };
  };
}
