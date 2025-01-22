{ config, lib, pkgs, ... }:
let
  aerospace-plugin = pkgs.writeShellScriptBin "aerospace-plugin" ''
  if [ "$1" = "$(aerospace list-workspaces --focused)" ]; then
      sketchybar --set space.$1 background.drawing=on
  else
  sketchybar --set space.$1 background.drawing=off
  fi

  MONITOR="$(aerospace list-workspaces --all --format "%{workspace}" | grep "^$1|" | cut '-d|' -f 2- )"
  if test -n "$MONITOR"; then
      sketchybar --set space.$1 icon="$MONITOR"
  fi
  COUNT="$(aerospace list-windows --workspace "$1" --count)"
  if test -n "$COUNT"; then
      if test "$COUNT" -eq 0; then
         sketchybar --set space.$1 label.color=0xfff5a97f
      else
         sketchybar --set space.$1 label.color=0xffcad3f5
      fi
  fi
'';

in
{
  services.sketchybar = {
    enable = true;
    extraPackages = with pkgs; [
      lua5_4_compat
    ];
    config = with pkgs; ''
      BLACK=0xff181926
      WHITE=0xffcad3f5
      RED=0xffed8796
      GREEN=0xffa6da95
      BLUE=0xff8aadf4
      YELLOW=0xffeed49f
      ORANGE=0xfff5a97f
      MAGENTA=0xffc6a0f6
      GREY=0xff939ab7
      TRANSPARENT=0x00000000

      # General bar colors
      BAR_COLOR=0xcc24273a
      ICON_COLOR=$WHITE # Color of all icons
      LABEL_COLOR=$WHITE # Color of all labels
      BACKGROUND_1=0xff3c3e4f
      BACKGROUND_2=0xff494d64

      POPUP_BACKGROUND_COLOR=$BLACK
      POPUP_BORDER_COLOR=$WHITE

      SHADOW_COLOR=$BLACK
      sketchybar --add event aerospace_workspace_change


      sketchybar --bar height=37        \
                  blur_radius=30   \
                  position=top     \
                  sticky=off       \
                  padding_left=10  \
                  padding_right=10


      for sid in $(aerospace list-workspaces --all); do
            sketchybar --add item space.$sid left \
                  --subscribe space.$sid aerospace_workspace_change \
                  --set space.$sid \
                  background.color=0xffed8796 \
                  background.border_color=0xffed8796 \
                  background.corner_radius=5 \
                  background.height=20 \
                  background.drawing=off \
                  icon.color=$WHITE \
                  icon.font="Noto Color Emoji:Mono:14.0" \
                  icon.padding_left=10                  \
                  icon.padding_right=4                  \
                  label="$sid" \
                  click_script="aerospace workspace $sid" \
                  script="${aerospace-plugin}/bin/aerospace-plugin $sid"
      done
      sketchybar --update
    '';
  };
}
