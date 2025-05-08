{ config, lib, pkgs, nixpkgs, hyprland, ... }:

with lib;
{
programs.hyprland = {
	enable = true;
};
environment.sessionVariables = {
	NIXOS_OZONE_WL = "1";	# Hint for Electron apps to use Wayland
};
}


