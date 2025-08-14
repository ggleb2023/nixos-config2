# for help type nixos-help :3

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disko.nix
    inputs.sops-nix.nixosModules.sops
    ./modules/vm.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config.allowUnfree = true;
  };

  nix =

    let

      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;

    in
    {

      settings = {

        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
      };
      # Opinionated: disable channels
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

    };

#  musnix = {
#    enable = true;
#    rtcqs.enable = true;
#    kernel.realtime = true;
#  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-console
  ];

  security.polkit.enable = true;

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
    "modesetting"
  ];

  services = {

    udev.packages = [ pkgs.gnome-settings-daemon ];

    #thermald.enable = true;

    #tlp = {
    #	enable = true;
    #	settings = {
    #	CPU_SCALING_GOVERNOR_ON_AC = "performance";
    #	CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    #
    #	CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    #	CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    #
    #	CPU_MIN_PERF_ON_AC = 0;
    #	CPU_MAX_PERF_ON_AC = 100;
    #	CPU_MIN_PERF_ON_BAT = 0;
    #	CPU_MAX_PERF_ON_BAT = 20;
    #
    #	#Optional helps save long term battery health
    #	START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
    #	STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    #
    #	};
    #};

    pulseaudio.enable = false;

    blueman.enable = true;

    libinput.mouse.accelSpeed = "0.0";

    libinput.enable = true;

    xserver = {
      xkb = {
        layout = "us, ru";
        variant = "";
        options = "";
      };
    };

    #displayManager.sddm.enable = true;
    #desktopManager.plasma6.enable = true;

    # tailscale = {
    #   enable = true;

    # };

    # openssh.enable = true;

    # i2pd = {
    #   enable = true;
    #   websocket.enable = true;
    # };

    # sunshine = {
    #   enable = true;
    #   autoStart = true;
    #   capSysAdmin = true;
    #   openFirewall = true;
    # };

    #  gvfs.enable = true;
    #   printing.enable = true;

  };

  programs = {

#    obs-studio = {
#      enable = true;
#
#      # optional Nvidia hardware acceleration
#      package = (
#        pkgs.obs-studio.override {
#          cudaSupport = true;
#        }
#      );
#
#      plugins = with pkgs.obs-studio-plugins; [
#        wlrobs
#        obs-backgroundremoval
#        obs-pipewire-audio-capture
#        obs-gstreamer
#        obs-vkcapture
#      ];
#    };

    clash-verge = {

      enable = true;

    };

    # appimage.enable = true;
    # appimage.binfmt = true;
    #programs.appimage.package = pkgs.appimage-run.override { extraPkgs = pkgs: [
    #pkgs.python312
    #]; };

    steam = {
      enable = true;
      # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    # mtr.enable = true;

    # gnupg.agent = {
    # enable = true;
    # enableSSHSupport = true;
    # };

    # kdeconnect.enable = true;

    # firefox.enable = false;

  };

  environment.systemPackages = with pkgs; [
    gzdoom
    prismlauncher
    ghostty
    font-awesome
    blender
    telegram-desktop
    fastfetch
    btop
    usbutils
    hyfetch
    pciutils
    unrar
    p7zip
    unp
    qbittorrent
    qdirstat
    gimp
    krita
    floorp
    gcc
    ffmpeg
    mars-mips
    age
    inputs.agenix.packages."${system}".default
    #(retroarch.withCores (
    #  cores: with cores; [
    #    snes9x
    #    ppsspp
    #  ]
    #))

  (vscode-with-extensions.override {
    vscode = vscodium;
    #vscodeExtensions = with vscode-extensions; [
    #  bbenoist.nix
    #  ms-python.python
    #  ms-azuretools.vscode-docker
#ms-vscode-remote.remote-ssh
#] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    #  {
    #    name = "remote-ssh-edit";
    #    publisher = "ms-vscode-remote";
    #    version = "0.47.2";
    #    sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
    #  }
    #];
  })
  ];

  hardware = {

    bluetooth = {

      enable = true;
      powerOnBoot = true;

    };

    opentabletdriver.enable = true;

  };

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Riga";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # SOUND
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  hardware.pulseaudio.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gleb = {
    isNormalUser = true;
    description = "gleb";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  users.extraUsers.gleb.extraGroups = [ "audio" ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
