{ pkgs, lib, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "spotify" ];

  # import the flake's module for your system
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  # configure spicetify :)
  programs.spicetify = {
    enable = true;
    # theme = spicePkgs.themes.comfy;
    enabledExtensions = with spicePkgs.extensions; [
      betterGenres
      lastfm
      volumePercentage
      adblock
      history
      songStats
      playlistIntersection
      shuffle
      powerBar
      fullAlbumDate
      fullAppDisplayMod
      goToSong
      showQueueDuration
      skipAfterTimestamp
      autoVolume
    ];
  };
}
