{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  ghostty-mock = pkgs.writeShellScriptBin "gostty-mock" ''
    true
  '';
in
{
  programs.ghostty = {
    enable = true;
    package = if (pkgs.stdenv.isDarwin) then ghostty-mock else pkgs.gostty;
    settings = {
      shell-integration = "fish";
      command = "${pkgs.fish}/bin/fish --login --interactive";
      macos-option-as-alt = true;
      # Disables ligatures
      font-feature = [
        "-liga"
        "-dlig"
        "-calt"
      ];
      confirm-close-surface = false;
    };
  };
}
