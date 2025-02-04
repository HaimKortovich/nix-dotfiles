{ inputs, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    policies = {
      Extensions = {
        Locked = [
          "uBlock0@raymondhill.net"
        ];
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          default_area = "navbar";
        };
      };
    };
    profiles = {
      admin = {
        id = 0;
        name = "admin";
        isDefault = true;
        extensions = with inputs.firefox-addons.packages.${pkgs.system}; [ ublock-origin ];
        search = {
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nix" ];
            };
          };
        };
      };
    };
  };
}
