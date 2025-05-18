{ pkgs, lib, ... }:

{
vim = {
	theme = {
		enable = true;
		name = "gruvbox";
		style = "light";
		};
	languages = {
		enableLSP = true;
		enableTreesitter = true;

		nix.enable = true;
		rust.enable = true;
		clang.enable = true;
		typst.enable = true;
		};

	statusline.lualine.enable = true;
	telescope.enable = true;
	autocomplete.nvim-cmp.enable = true;

	};

}
