{pkgs, inputs, config, ...}:{

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri.package = pkgs.niri;

  programs.niri ={
  
    enable = true;
    settings = {
    
      environment."NIXOS_OZONE_WL" = "1";
    
    };

  };

}
