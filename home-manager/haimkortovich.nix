# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  ...
}:

{
  # You can import other home-manager modules here
  imports = [
    inputs.mac-app-util.homeManagerModules.default
    ./features/direnv.nix
    ./features/doom
    ./features/starship.nix
    ./features/stylix.nix
    ./features/fish.nix
    ./features/ghostty.nix
    ./features/spicetify.nix
    ./features/neovim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "haimkortovich";
    homeDirectory = "/Users/haimkortovich";
  };

  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName  = "Haim Kortovich";
    userEmail = "haim.kortovich@topmanage.com";
    extraConfig = {
      url."ssh://git@bitbucket.org/".insteadOf = "https://bitbucket.org/";
    };
  };

  xdg.enable = true;

  home.sessionPath = [ "$HOME/.local/bin" ];
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
