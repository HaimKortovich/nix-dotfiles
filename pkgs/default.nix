# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{ pkgs, ... }:
{
  # example = pkgs.callPackage ./example { };
  # kontroll = pkgs.callPackage ./kontroll.nix { };
}
