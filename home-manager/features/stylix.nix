{ pkgs, inputs, ... }:
{
  imports = [ inputs.stylix.homeManagerModules.stylix ];
  stylix = {
  image =  pkgs.fetchurl {
    url = "https://images4.alphacoders.com/735/73556.jpg";
    sha256 = "sha256-uPHzwtbEtz6wce2Xbb461DXLLKAVMJAUSdObEHIQGEA";
  };
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  };
}
