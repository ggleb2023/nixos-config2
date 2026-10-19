# for help type nixos-help :3
{ inputs, lib, config, pkgs, ...  }:
let
   localProxy = "127.0.0.1:2080";
in
{
home-manager.backupFileExtension = "backup";

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
    #./modules/vm.nix
    ./modules/nvf.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      inputs.helium.overlays.default
      #
      # #inputs.niri.overlays.niri
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
  # programs.niri.package = pkgs.niri-unstable;

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = ["nix-command flakes"];
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;

#     fallback = true;
#     connect-timeout = 2;
#     stalled-download-timeout = 4;
#     download-attempts = 2;
#     http-connections = 32;
#     max-substitution-jobs = 32;
#     builders-use-substitutes = true;
     auto-optimise-store = true;
     
     substituters = lib.mkForce [ "http://localhost:8080" ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g="
    ];

      trusted-substituters = [ "http://localhost:8080" ];


      # Opinionated: disable channels
     

      # Opinionated: make flake registry and nix path match flake inputs

};
 channel.enable = true;
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

};

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
    };
  };

  musnix = {
    enable = false;
    rtcqs.enable = false;
    kernel.realtime = false;
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };
  boot.kernel.sysctl."kernel.sysrq" = 1;

  services.ncro = {
    enable = true;
    settings = {
      upstreams = [
        {url = "https://cache.nixos.org";
          priority = 90;
          public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";}
        {url = "https://nix-community.cachix.org";
          priority = 89;
          public_key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";}
        {url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store";
         priority = 10;
         public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";}
        {url = "https://mirrors.ustc.edu.cn/nix-channels/store";
         priority = 20;
         public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";}
        {url = "https://mirrors.bfsu.edu.cn/nix-channels/store";
         priority = 30;
         public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";}
        {url = "https://mirror.sjtu.edu.cn/nix-channels/store";
         priority = 40;
         public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";}
         {url = "https://mirror.nyist.edu.cn/nix-channels/store";
         priority = 50;
         public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";}
         {url = "https://mirror.lzu.edu.cn/nix-channels/store";
         priority = 1;
         public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";}
         {url = "https://mirror.cqupt.edu.cn/nix-channels/store";
         priority = 70;
         public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";}
         {url = "https://winapps.cachix.org";
         priority = 80;
         public_key = "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g=";}
      ];
    };
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  services.pcscd.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [
    "amdgpu"
  ];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];
  hardware.graphics.enable32Bit = true; # For 32 bit applications
  hardware.graphics.enable = true;
  # hardware.graphics.extraPackages = with pkgs; [
  #   amdvlk
  # ];
  # # For 32 bit applications
  # hardware.graphics.extraPackages32 = with pkgs; [
  #   driversi686Linux.amdvlk
  # ];
  hardware.opengl.enable = true;
  hardware.enableAllFirmware = true;
  services.flatpak.enable = true;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  zramSwap.enable = true;

  #  environment.gnome.excludePackages = with pkgs; [
  #    atomix # puzzle game
  #    cheese # webcam tool
  #    epiphany # web browser
  #    evince # document viewer
  #    geary # email reader
  #    gedit # text editor
  #    gnome-characters
  #    gnome-music
  #    gnome-photos
  #    gnome-terminal
  #    gnome-tour
  #    hitori # sudoku game
  #    iagno # go game
  #    totem # video player
  #  ];
  #
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  services = {
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm.enable = true;
    };
    desktopManager.gnome.extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
    '';

    udev.packages = [
      pkgs.gnome-settings-daemon
    ];

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
        options = "grp:win_space_toggle";
      };
    };

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
  # services.zapret.enable = true;
  # services.zapret.whitelist = [
  #   "youtube.com"
  #   "googlevideo.com"
  #   "ytimg.com"
  #   "youtu.be"
  #   "discord.com"
  #   "discord-attachmets-uploads-prd.storage.googleapis.com"
  #   "googleapis.com"
  # ];
  # services.zapret.params = [
  #   "--dpi-desync=fake,disorder2"
  #   "--dpi-desync-ttl=1"
  #   "--dpi-desync-autottl=2"
  # ];
  #
  programs = {

    throne = {
      enable = true;
      tunMode.enable = true;
    };

    fish.enable = true;

    direnv = {
      enable = true;
    };

    # amnezia-vpn.enable = true;

    #niri.enable = false;
    #obs-studio = {
    #  enable = true;
    #  plugins = with pkgs.obs-studio-plugins; [
    #    wlrobs
    #    obs-pipewire-audio-capture
    #    obs-gstreamer
    #    obs-vkcapture
    #  ];
    #};

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
  };
  fonts.packages = with pkgs; [
    font-awesome
    iosevka
    
  ];
  environment.systemPackages =
    with pkgs;
    [
      blender
      inputs.winapps.packages."${pkgs.system}".winapps
      inputs.winapps.packages."${pkgs.system}".winapps-launcher
      gnome-solanum
      helium
      lact
      gnomeExtensions.appindicator
      gnomeExtensions.just-perfection
      gnomeExtensions.blur-my-shell
      gnomeExtensions.hide-top-bar
      gnomeExtensions.caffeine
      kdePackages.sddm-kcm
      kdePackages.kleopatra
      pinentry-curses
      #jetbrains.idea-community
      wayland-utils
      # osu-lazer-bin
      wl-clipboard
      onlyoffice-desktopeditors
      #(ffmpeg-full.override { withUnfree = true; })
      prismlauncher
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
      floorp-bin
      gcc
      mars-mips
      age
      inputs.agenix.packages."${system}".default
      #(retroarch.withCores (
      #  cores: with cores; [
      #    snes9x
      #    ppsspp
      #  ]
      #))

      #(vscode-with-extensions.override {
      #  vscode = vscodium;
      #})
    ]
    ++ [ inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.krita ];

services.emacs = {
  enable = true;
  defaultEditor = true;
};  

  hardware = {
    bluetooth = {
      enable = true;
      # powerOnBoot = true;
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
  networking.proxy = {
    default = "${localProxy}";
    noProxy = "127.0.0.1,localhost,internal.domain";
  };
  environment.variables = {
    http_proxy = "${localProxy}";
    https_proxy = "${localProxy}";
    #NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
};

 #for systemd other services
 # systemd.services.<something>.environment = {
 #  http_proxy = "${localProxy}";
 #  https_proxy = "${localProxy}";
 # };
 # 
  # Set your time zone.
  time.timeZone = "Asia/Pyongyang";

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
    # media-session.enable = true;
    wireplumber.enable = true;
  };
  hardware.pulseaudio.enable = false;

    services.pipewire.wireplumber.extraConfig."11-bluetooth-policy" = {
    "wireplumber.settings" = {
      "bluetooth.autoswitch-to-headset-profile" = false;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gleb = {
    isNormalUser = true;
    description = "gleb";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  users.extraUsers.gleb.extraGroups = [ "audio" ];
  time.hardwareClockInLocalTime = true;

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
  system.stateVersion = "26.05"; # Did you read the comment?
}
