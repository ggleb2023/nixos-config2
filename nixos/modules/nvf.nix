{pkgs, ...}:
{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
      lsp = {
        enable = true;
        formatOnSave = true;
      };
      languages = {
        enableFormat = true;
        enableTreesitter = true;

        assembly.enable = true;
        clang.enable = true;
        typst.enable = true; 
        rust.enable = true;
        nix.enable = true;
        };
      };
    };
  };
}
