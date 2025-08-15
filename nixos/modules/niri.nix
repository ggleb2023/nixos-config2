{pkgs, ...} : 

{
  nipkgs.overlays = [inputs.niri.overlays.niri];
  programs.niri.enable = true;
  programs.niri.settings = {
    outputs."eDP-1".scale = 1.5;
    environment."NIXOS_OZONE_WL" = "1";
  
  };



}

