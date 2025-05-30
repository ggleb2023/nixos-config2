{ 
description = "wawa";

inputs = {

# Nixpkgs 
nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

# Home manager
home-manager.url = "github:nix-community/home-manager";
home-manager.inputs.nixpkgs.follows = "nixpkgs";

quickemu.url = "https://flakehub.com/f/quickemu-project/quickemu/4.9.7";
quickemu.inputs.nixpkgs.follows = "nixpkgs";

#NVF
nvf.url = "github:notashelf/nvf";
nvf.inputs.nixpkgs.follows = "nixpkgs";

# Disko
disko.url = "github:nix-community/disko/latest";
disko.inputs.nixpkgs.follows = "nixpkgs";

# Hyprland
hyprland.url = "github:hyprwm/Hyprland";
hyprland.inputs.nixpkgs.follows = "nixpkgs";

# Cachix
cachix.url = "github:cachix/cachix";
cachix.inputs.nixpkgs.follows = "nixpkgs";

# sops-nix
sops-nix.url = "github:Mic92/sops-nix";
sops-nix.inputs.nixpkgs.follows = "nixpkgs";

# Agenix
agenix.url = "github:ryantm/agenix";
agenix.inputs.nixpkgs.follows = "nixpkgs";

};

outputs = {
self, nixpkgs,
home-manager, disko, hyprland, cachix, sops-nix, agenix, nvf, quickemu, ...
} 

@ inputs: let inherit (self) outputs;
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
		sops-nix.nixosModules.sops
		agenix.nixosModules.default
		nvf.nixosModules.default

		home-manager.nixosModules.home-manager
		{
			home-manager = {
				useGlobalPkgs = true;
				useUserPackages = true;
				users.gleb = import ./home-manager/home.nix;
				extraSpecialArgs = { inherit inputs; };	
			};
		}

];
	};
};

##NVF standalone
#packages."x86_64-linux".default = 
#	(nvf.lib.neovimConfiguration {
#	pkgs = nixpkgs.legacyPackages."x86_64-linux";
#	modules = [./nixos/modules/nvf-configuration.nix];
#	}).neovim;
#
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
