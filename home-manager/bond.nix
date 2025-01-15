{ inputs, ... }:
{
  imports = [
    ./features/direnv.nix
    ./features/doom
    ./features/starship.nix
    ./features/stylix.nix
    ./features/fish.nix
    ./features/ghostty.nix
  ];

  nixpkgs = {
    # overlays = [
    #   inputs.self.overlays.additions
    #   inputs.self.overlays.stable-packages
    #   inputs.self.overlays.rosetta-packages
    #   inputs.self.overlays.modifications
    # ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "bond";
    homeDirectory = "/home/bond";
  };

  programs.home-manager.enable = true;

  xdg.enable = true;

  home.stateVersion = "24.11";
}
