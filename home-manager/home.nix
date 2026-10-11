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
    #../nixos/modules/niri.nix
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

  home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";

  # GTK theming settings
  gtk = {
    enable = true;
    #Icon Theme
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      # package = pkgs.kdePackages.breeze-icons;
      # name = "Breeze-Dark";
    };
  };

  xdg.configFile."emacs".source = ../emacs;

  programs = {
  
  emacs = {
    enable = true;
    package = pkgs.emacs-nox;
  };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      plugins = [
        # Manually packaging and enable a plugin
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
            sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
          };
        }
      ];
    };

    home-manager.enable = true;

    foot = {
    	 enable = true;
	 settings = {
	 	main = {
		     term = "foot";
		     font = "iosevka:size=11";
		     dpi-aware = "yes";
		     initial-color-theme = "light";
		     };
		mouse.hide-when-typing = "yes";
		csd.size = 0;
	colors-light = {
	cursor="eeeeee 444444";
	background="eeeeee";
	foreground="444444";
	regular0="eeeeee";  # black
	regular1="af0000";  # red
	regular2="008700";  # green
	regular3="5f8700";  # yellow
	regular4="0087af";  # blue
	regular5="878787";  # magenta
	regular6="005f87";  # cyan
	regular7="764e37";  # white
	bright0="bcbcbc";   # bright black
	bright1="d70000";   # bright red
	bright2="d70087";   # bright green
	bright3="8700af";   # bright yellow
	bright4="d75f00";   # bright blue
	bright5="d75f00";   # bright magenta
	bright6="4c7a5d";   # bright cyan
	bright7="005faf";   # bright white
	selection-foreground="eeeeee";
	selection-background="0087af";
	};


};

    };

    ghostty = {
      enable = true;
      enableBashIntegration = true;
      installVimSyntax = true;
    };

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

    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-airline ];
      settings = {
        ignorecase = true;
      };
      extraConfig = ''
              set mouse=a
        set shiftwidth=4 smarttab
      '';
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.05";
}
