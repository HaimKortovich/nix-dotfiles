{ pkgs, inputs, lib, config, ... }:
{
  imports = [ inputs.nix-doom-emacs.hmModule ];
  home.packages = [ pkgs.ispell ];
  programs.doom-emacs = {
    enable = true;
    emacs = pkgs.emacs29-pgtk.overrideAttrs (old: {
      patches =
        (old.patches or [])
        ++ [
          # Fix OS window role (needed for window managers like yabai)
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
            sha256 = "sha256-+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
          })
          # Enable rounded window with no decoration
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/round-undecorated-frame.patch";
            sha256 = "sha256-uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
          })
          # Make Emacs aware of OS-level light/dark mode
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/system-appearance.patch";
            sha256 = "sha256-oM6fXdXCWVcBnNrzXmF0ZMdp8j0pzkLE66WteeCutv8=";
          })
        ];
    });
    doomDir = ./doom.d; # Directory containing your config.el, init.el
    # doomPackageDir = pkgs.linkFarm "my-doom-packages" [
    #        # straight needs a (possibly empty) `config.el` file to build
    #        { name = "config.el"; path = pkgs.emptyFile; }
    #        { name = "init.el"; path = ./doom.d/init.el; }
    #        { name = "packages.el"; path = ./packages/packages.el; }
    #      ];
  };
}
