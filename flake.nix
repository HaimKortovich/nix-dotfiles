{
  description = "Nix configs";

  inputs = {
    # Nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
    nixvim.url = "github:nix-community/nixvim/nixos-24.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "";
    };
    # Fix .app programs installed by Nix on Mac
    mac-app-util.url = "github:hraban/mac-app-util";
    slippi.url = "github:lytedev/slippi-nix";
    stylix.url = "github:danth/stylix/release-24.11";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      ...
    }@inputs:
    let
      # Supported systems for flake packages, shell, etc.
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # Custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      # Formatter for the nix files, available through 'nix fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable nix-darwin modules you might want to export
      # These are usually stuff you would upstream into nix-darwin
      darwinModules = import ./modules/darwin;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      templates = import ./templates;
      
      nixosConfigurations = {
        skyfall = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./hosts/skyfall/configuration.nix ];
        };
      };
      # macOS systems using nix-darwin
      # darwinConfigurations = {
      #   TAG-761 = darwin.lib.darwinSystem {
      #     system = "aarch64-darwin";
      #     specialArgs = {
      #       inherit inputs;
      #     };
      #     modules = [
      #       ./hosts/tag-761.nix
      #     ];
      #   };
      # };

      homeConfigurations = {
        "haimkortovich@TAG-761" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [ ./home-manager/haimkortovich.nix ];
        };
        "bond@skyfall" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [ ./home-manager/bond.nix ];
        };
      };
    };
}
