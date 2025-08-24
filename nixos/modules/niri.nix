{ pkgs, inputs, config, lib, ... }: 
{
    services.swww.enable = true;

    programs.niri = {
      settings = {
        environment."NIXOS_OZONE_WL" = "1";
        outputs."eDP-1".scale = 1.25;
        spawn-at-startup = [
          { command = [ "swww-daemon" ]; }
          { command = [ "waybar" ]; }
          { command = [ "xremap" "~/.config/xremap/config.yaml" "--device" "/dev/input/event2" "--device" "/dev/input/event3" ]; }
        ];
        input = {
          keyboard.xkb = {
            layout = "us,ru";
            options = "grp:win_space_toggle";
          };
          touchpad = {
            click-method = "clickfinger";
            natural-scroll = true;
            scroll-method = "two-finger";
            scroll-factor = 0.15;
            tap = true;
            dwt = true;
          };
          mouse = {
            accel-profile = "flat";
          }; 
        };
        layout = {
          gaps = 16;
          center-focused-column = "never";
          preset-column-widths = [
            { proportion = 1.0 / 3.0; }
            { proportion = 1.0 / 2.0; }
            { proportion = 1.0; }
          ];
          default-column-width = {
            proportion = 1.0 / 1.5;
          };
          focus-ring = {
            width = 4;
          };
          struts = {
            left = 48;
            right = 48;
            bottom = 32;
            top = 32;
          };
        };
            binds =
          with config.lib.niri.actions;
          let
            mod = "Super";
          in
          {
            "${mod}+F".action = fullscreen-window;
            "${mod}+M".action = spawn "${pkgs.swaynotificationcenter}/bin/swaync-client" "-t";
            "${mod}+Return".action = spawn "${pkgs.kitty}/bin/kitty";
            "${mod}+Shift+E".action = spawn "${pkgs.wlogout}/bin/wlogout";
            "${mod}+Shift+Q".action = close-window;
            "${mod}+G".action = spawn "${pkgs.wofi}/bin/wofi" "--show" "drun" "-Ibm" "-W" "576";
            "${mod}+V".action = toggle-window-floating;
            "${mod}+Ctrl+L".action = spawn "${pkgs.swaylock}/bin/swaylock";
            
            "${mod}+Shift+S".action = screenshot;

            #audio
            "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-";
            "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+";
            "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";

            # movement
            "${mod}+H".action = focus-column-left;
            "${mod}+L".action = focus-column-right;
            "${mod}+K".action = focus-window-or-workspace-up;
            "${mod}+J".action = focus-window-or-workspace-down;

            # window manipulation
            "${mod}+Shift+H".action = move-column-left;
            "${mod}+Shift+L".action = move-column-right;
            "${mod}+Shift+K".action = move-window-up-or-to-workspace-up;
            "${mod}+Shift+J".action = move-window-down-or-to-workspace-down;

            "${mod}+Minus".action = set-column-width "-10%";
            "${mod}+Equal".action = set-column-width "+10%";

            "${mod}+Shift+Minus".action = set-window-height "-10%";
            "${mod}+Shift+Equal".action = set-window-height "+10%";

            "${mod}+A".action = consume-window-into-column;
            "${mod}+R".action = expel-window-from-column;
            "${mod}+S".action = switch-preset-column-width;
         };
      };
    };
}
