{ config, inputs, ...}:

{
  imports = [ inputs.slippi.homeManagerModules.default ];
  slippi-launcher.isoPath = "~/roms/melee.iso";
}

