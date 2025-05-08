{ config, lib, pkgs, nixpkgs, hyprland, ... }:

with lib;
{
programs.hyprland = {
	enable = true;
};
environment.sessionVariables = {
	WLR_NO_HARDWARE_CURSORS = "1";
	NIXOS_OZONE_WL = "1";	# Hint for Electron apps to use Wayland
	XDG_CURRENT_DESKTOP = "Hyprland";
	XDG_SESSION_DESKTOP = "Hyprland";
	XDG_SESSION_TYPE = "wayland";
};
}


