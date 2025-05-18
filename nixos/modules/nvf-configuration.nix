{ pkgs, lib, ... }:

{
vim = {
	theme = {
		enable = true;
		name = "gruvbox";
		style = "light";
		};
        lsp.enable = true;
        languages = {
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
