{inputs, pkgs, lib, ... }:

with lib;
{
nix.settings = {
	extra-substituters = [
		"https://hyprland.cachix.org"
		"https://cache.nixos.org/"
	];
	extra-trusted-public-keys = [
		"hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
		"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
	];
};

programs.hyprland = {
	enable = true;
	xwayland.enable = true;
	# set the flake package
	package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
	# make sure to also set the portal package, so that they are in sync
	portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

};

xdg.portal = {
	enable = true;
	extraPortals = [pkgs.xdg-desktop-portal-wlr];
};

services.greetd = {
	enable = true;
	settings = {
	default_session = {
	command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
	user = "greeter";
	};
	};
};

environment.sessionVariables = {
	WLR_RENDERER =" vulkan";
	__GLX_VENDOR_LIBRARY_NAME="nvidia";
	GBM_BACKEND = "nvidia-drm";
	WLR_NO_HARDWARE_CURSORS = "1";
	NIXOS_OZONE_WL = "1";	# Hint for Electron apps to use Wayland
	QT_QPA_PLATFORM = "wayland";

	systemPackages = with pkgs; [ 
	uwsm
	waybar
	dunst
	libnotify
	swww
	rofi-wayland
	];
};

}



