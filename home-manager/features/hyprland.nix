{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    libnotify
    grim
    slurp
    pamixer
  ];
  
  imports = [ ./waybar.nix ./tofi.nix ];

  wayland.windowManager.hyprland = {
    enable = true;
    
    xwayland.enable = true;

    settings = {
      "$MOD" = "SUPER";
      "$TERMINAL" = "ghostty";
      "$BROWSER" = "firefox";
      "$MENU" = "tofi-run | xargs hyprctl dispatch exec";

      xwayland = {
        force_zero_scaling = "true";
      };

      ecosystem.no_update_news = "true";
      
      env = [
        "XCURSOR_SIZE,24"
      ];

      monitor = [
        ",preferred,auto,auto"
      ];
      exec-once = [
        "waybar"
      ];
      input = {
        kb_layout = "us";
        kb_rules = "";
        follow_mouse = "1";
        sensitivity = "0";
        repeat_rate = "60";
        repeat_delay = "200";
      };
      general = {
        gaps_in = "5";
        gaps_out = "20";
        border_size = "2";
        resize_on_border = "true";
        layout = "dwindle";
        allow_tearing = "false";
      };
      cursor = {
        inactive_timeout = "3";
      };
      decoration = {
        rounding = "10";
        inactive_opacity = "0.8";
        blur = {
          enabled = "true";
          size = "5";
          passes = "2";
          new_optimizations = "true";
          xray = "true";
          ignore_opacity = "true";
        };
      };
      animations = {
        enabled = "true";
      };
      dwindle = {
        pseudotile = "true";
        preserve_split = "true";
      };
      master = {
        new_status = "master";
      };
      gestures = {
        workspace_swipe = "true";
      };
      misc = {
        force_default_wallpaper = "0";
        disable_hyprland_logo = "true";
        disable_splash_rendering = "true";
      };
      bind =
        [
          "$MOD, return, exec, $TERMINAL"
          "$MOD, z, exec, $BROWSER"
          "$MOD, e, exec, emacs"
          "$MOD, x, exec, $TERMINAL"
          "$MOD, w, exec, $MENU"
          "$MOD, q, killactive"
          "$MOD, v, togglefloating"
          "$MOD, p, pseudo"
          "$MOD, s, togglesplit"
          "$MOD SHIFT, s, pin"
          "$MOD, f, fullscreen"
          "$MOD, w, togglegroup"
          "$MOD, page_down, changegroupactive, b"
          "$MOD, page_up, changegroupactive, f"
          "$MOD, left, movefocus, l"
          "$MOD, right, movefocus, r"
          "$MOD, up, movefocus, u"
          "$MOD, down, movefocus, d"
          "$MOD, h, movefocus, l"
          "$MOD, l, movefocus, r"
          "$MOD, k, movefocus, u"
          "$MOD, j, movefocus, d"
          "$MOD SHIFT, left, movewindow, l"
          "$MOD SHIFT, right, movewindow, r"
          "$MOD SHIFT, up, movewindow, u"
          "$MOD SHIFT, down, movewindow, d"
          "$MOD SHIFT, h, movewindow, d"
          "$MOD SHIFT, l, movewindow, r"
          "$MOD SHIFT, k, movewindow, u"
          "$MOD SHIFT, j, movewindow, d"
          "$MOD, n, togglespecialworkspace, scratchpad"
          "$MOD SHIFT, g, movetoworkspace, special:scratchpad"
          "$MOD, g, togglespecialworkspace, scratchpad2"
          "$MOD SHIFT, g, movetoworkspace, special:scratchpad2"
          "$MOD, d, togglespecialworkspace, scratchpad3"
          "$MOD SHIFT, d, movetoworkspace, special:scratchpad3"
          "$MOD, mouse_down, workspace, e+1"
          "$MOD, mouse_up, workspace, e-1"
        ]
        ++ (
          # workspaces
          # binds $MOD + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i;
              in
              [
                "$MOD, ${toString i}, workspace, ${toString ws}"
                "$MOD SHIFT, ${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
        );
      bindm = [
        "$MOD, mouse:272, movewindow"
        "$MOD, mouve:273, resizewindow"
      ];
      windowrulev2 = [
        "suppressevent maximize, class:.*" # You'll probably like this.
        "float,class:org.keepassxc.KeePassXC"
        "workspace special:scratchpad silent,class:org.keepassxc.KeePassXC"
        "workspace special:scratchpad3 silent,class:Supersonic"
        "float,class:mpv"
        "opaque,class:mpv"
        "float,title:^(swayimg)(.*)$"
        "float,title:^(imv)(.*)$"
        "float,title:^(Ouvrir)(.*)$"
        "float,title:^(Extension)(.*)$"
        "float,title:^(Add)(.*)$"
        "fullscreen,class:gamescope"
        "forcergbx,class:gamescope"
        "opaque,title:(.*)(- YouTube)(.*)$"
      ];
    };
    extraConfig = ''
      # Submap resize
      bind = $MOD, r, submap, resize # will switch to a submap called resize
      submap = resize # will start a submap called "resize"
      bind = , h, resizeactive, -50 0
      bind = , j, resizeactive, 0 50
      bind = , k, resizeactive, 0 -50
      bind = , l, resizeactive, 50 0
      bind = , escape, submap, reset # use reset to go back to the global submap
      bind = , q, submap, reset # use reset to go back to the global submap
      submap = reset # will reset the submap, meaning end the current one and return to the global one.

      # Poweroff menu
      bind = $MOD SHIFT, q, submap, poweroff
      submap = poweroff
      bind = , p, exec, poweroff
      bind = , r, exec, reboot
      bind = , s, exec, systemctl suspend
      bind = , m, exit,
      # bind = , l,
      bind = , q, submap, reset
      bind = , escape, submap, reset
      submap = reset # will reset the submap, meaning end the current one and return to the global one.
    '';
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ config.stylix.image ];
      wallpaper = [
        "eDP-1,${config.stylix.image}"
        "DP-3,${config.stylix.image}"
        "DP-5,${config.stylix.image}"
        "HDMI-A-1,${config.stylix.image}"
      ];
    };
  };
}
