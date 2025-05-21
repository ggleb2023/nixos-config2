{ pkgs, lib, ... }:

{
programs.nvf = {

enable = true;
settings = {
vim = {
	theme = {
		enable = true;
		name = "github";
style = "dark";
		};
        lsp.enable = true;
        languages = {
        enableTreesitter = true;

		nix.enable = true;
		rust.enable = true;
                rust.crates.enable = true;
                rust.treesitter.enable = true;
		clang.enable = true;
		typst.enable = true;
		};
        
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
};
};
};
}
