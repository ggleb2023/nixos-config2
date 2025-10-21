{ pkgs, ... }:
{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        startPlugins = with pkgs.vimPlugins; [
          vimtex
        ];
        options = {
          shiftwidth = 2;
          smartindent = true;
        };
        autocomplete.blink-cmp.enable = true;
        telescope.enable = true;
        statusline.lualine.enable = true;
        comments.comment-nvim.enable = true;
        autopairs.nvim-autopairs.enable = true;
        git.gitsigns.enable = true;

        lsp = {
          enable = true;
          formatOnSave = true;
        };
        languages = {
          enableFormat = false;
          enableTreesitter = true;

          assembly.enable = true;
          clang.enable = true;
          typst.enable = true;
          rust.enable = true;
          nix.enable = true;
          java.enable = true;
        };
        spellcheck = {
          enable = true;
          languages = [
            "en"
            "ru"
            "de"
          ];
        };
        ui = {
          noice.enable = true;

          borders = {
            enable = true;
            globalStyle = "rounded";

            plugins.nvim-cmp.enable = false;
          };
        };
      };
    };
  };
}
