# This is your system's configuration file.
# Use this to configure your system environment (it replaces ~/.nixpkgs/darwin-configuration.nix)
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  # You can import other nix-darwin modules here
  imports = [
    ./common/aerospace.nix
    # ./common/sketchybar.nix
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      trusted-users = [
        "root"
        "haimkortovich"
      ]; # For groups prepend @: "@admin"
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      extra-platforms = lib.optionalString (
        pkgs.system == "aarch64-darwin"
      ) "x86_64-darwin aarch64-darwin";

      # sandbox = true;
    };

    gc = {
      automatic = false; # See programs.nh.clean
      interval = {
        Day = 7;
      };
    };

    linux-builder = {
      enable = true;
      ephemeral = true;
    };
  };

  environment = {
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    systemPackages = with pkgs; [ vim ];
    # shells = with pkgs; [
    #   zsh
    #   bashInteractive
    # ];
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  services = {
    nix-daemon.enable = true; # Auto upgrade nix package and the daemon service.
    tailscale = {
      enable = false; # Using App Store application for the moment
      overrideLocalDns = false;
    };
  };

  networking.hostName = "TAG-761";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    fish.enable = true;
    zsh = {
      enable = true; # default shell on Catalina+
      enableFzfCompletion = true;
      enableFzfGit = true;
    };
  };

  users.users = {
    haimkortovich = {
      name = "haimkortovich";
      home = "/Users/haimkortovich";
    };
  };

  fonts.packages = [ pkgs.nerd-fonts.hack pkgs.noto-fonts-emoji ];

  homebrew = {
    enable = true;
    global.brewfile = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true; # This defaults to false so calls are idempotent.
    onActivation.cleanup = "zap";

    taps = [];
    casks = [
    "zoom"
    "maccy"
    # temp workaround
    "ghostty"
    ];
    brews = [ ];
    masApps = {
      "Microsoft Remote Desktop" = 1295203466;
    };
    # extraConfig = '' '';
    # whalebrews = [ ];
  };

  ## Other configs
  # Enable sudo authentication with Touch ID
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.expose-group-apps = true;
  # system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "bottom";
  # system.defaults.dock.showhidden = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  # system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.ShowStatusBar = true;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  system.defaults.magicmouse.MouseButtonMode = "TwoButton";

  system.defaults.NSGlobalDomain._HIHideMenuBar = config.services.spacebar.enable;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
