{ 
description = "Your new nix config";

inputs = {

# Nixpkgs
nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

# Home manager
	home-manager.url = "github:nix-community/home-manager/release-24.11";
	home-manager.inputs.nixpkgs.follows = "nixpkgs";

# Disko
disko.url = "github:nix-community/disko/latest";
disko.inputs.nixpkgs.follows = "nixpkgs";

# Hyprland
hyprland.url = "github:hyprwm/Hyprland";

cachix.url = "github:cachix/cachix";
cachix.inputs.nixpkgs.follows = "nixpkgs";
};


outputs = {
self, nixpkgs, home-manager, disko, hyprland, cachix, ...
} 

@ inputs: 
let inherit (self) outputs;

in {
# NixOS configuration entrypoint
# Available through 'nixos-rebuild --flake .#your-hostname'
nixosConfigurations = {
	nixos = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	specialArgs = {
		inherit inputs outputs;
		inherit disko;
		inherit hyprland nixpkgs;
	};
	# > Our main nixos configuration file <
	modules = [
		./nixos/configuration.nix
		disko.nixosModules.default
	];
	};
};

# Standalone home-manager configuration entrypoint
# Available through 'home-manager --flake .#your-username@your-hostname'
homeConfigurations = {
	"gleb@nixos" = home-manager.lib.homeManagerConfiguration {
	pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
	extraSpecialArgs = {inherit inputs outputs;};
	# > Our main home-manager configuration file <
	modules = [./home-manager/home.nix];
	};
};
};
}
