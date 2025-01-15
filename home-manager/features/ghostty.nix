{ pkgs, inputs, ... }:

{
  imports = [ inputs.ghostty.homeModules.default ];
  programs.ghostty = {
    enable = true;
    shellIntegration.enable = true;
    settings = {
      shell-integration = "fish";
      command = "${pkgs.fish}/bin/fish --login --interactive";
      background-blur-radius = 20;
      theme = "gruvbox-material";
      window-theme = "dark";
      background-opacity = 0.8;
      minimum-contrast = 1.1;
      font-size = 14;
      font-family = "JetBrainsMono Nerd Font";

      # The default is a bit intense for my liking
      # but it looks good with some themes
      unfocused-split-opacity = 0.96;
      macos-option-as-alt = true;

      # Disables ligatures
      font-feature = ["-liga" "-dlig" "-calt"];
      confirm-close-surface = false;
    };
  };
}

