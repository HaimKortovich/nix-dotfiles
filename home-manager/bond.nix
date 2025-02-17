{ inputs, pkgs, ... }:
{
  imports = [
    ./features/direnv.nix
    ./features/doom
    ./features/starship.nix
    ./features/stylix.nix
    ./features/fish.nix
    ./features/ghostty.nix
    ./features/spicetify.nix
    ./features/hyprland.nix
    ./features/neovim.nix
    ./features/slippi.nix
    ./features/firefox.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "bond";
    homeDirectory = "/home/bond";
    packages = with pkgs; [ steam prismlauncher ];
  };

  programs.home-manager.enable = true;

  xdg.enable = true;

  home.stateVersion = "25.05";
}
