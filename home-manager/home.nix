# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  #nixpkgs = {
  ## You can add overlays here
  #overlays = [
  ## If you want to use overlays exported from other flakes:
  ## neovim-nightly-overlay.overlays.default
  #
  ## Or define it inline, for example:
  ## (final: prev: {
  ##   hi = final.hello.overrideAttrs (oldAttrs: {
  ##     patches = [ ./change-hello-to-hi.patch ];
  ##   });
  ## })
  #];
  ## Configure your nixpkgs instance
  #config = {
  ## Disable if you don't want unfree packages
  #allowUnfree = true;
  ## Workaround for https://github.com/nix-community/home-manager/issues/2942
  #allowUnfreePredicate = _: true;
  #};
  #};

  home = {
    username = "gleb";
    homeDirectory = "/home/gleb";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = [
    (pkgs.writeShellScriptBin "nv" ''
      exec nix run ~/flakes/nixos-config2 "$@"
    '')
  ];

  # Enable home-manager and git
  programs = {

    home-manager.enable = true;

    git = {
      enable = true;
      userName = "ggleb2023";
      userEmail = "151332451+ggleb2023@users.noreply.github.com";
      signing = {
        key = "~/.ssh/id_ed25519.pub";
        signByDefault = true;
      };
      extraConfig = {
        gpg.format = "ssh";
        commit.gpgsign = true;
        tag.gpgsign = true;
        user.signingkey = "~/.ssh/id_ed25519.pub";
      };
    };

    ssh = {
      enable = true;
      extraConfig = ''
        	IdentityFile ~/.ssh/id_ed25519
        	'';
    };

    helix = {
      enable = true;
      settings = {
        theme = "autumn_night_transparent";
        editor.cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
        }
      ];
      themes = {
        autumn_night_transparent = {
          "inherits" = "autumn_night";
          "ui.background" = { };
        };
      };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
