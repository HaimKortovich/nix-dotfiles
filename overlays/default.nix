# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };
  rosetta-packages = final: _prev: {
    rosetta = if final.stdenv.isDarwin && final.stdenv.isAarch64 then final.pkgsx86_64Darwin else final;
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: prev: {
  };
}
