{ config, pkgs, ... }:
{
  #IMPORTS
  imports = [
    #HARDWARE
    ./hardware-configuration.nix
    #NIXVIM
    ./nixvim.nix

    #import-NIXVIM
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
      ref = "nixos-24.11";
    })).nixosModules.nixvim

    <musnix>
  ];

  environment.sessionVariables = {
    GI_TYPELIB_PATH = "run/current-system/sw/lib/girepository-1.0";
  };


  #MUSNIX
  musnix = {
    enable = true;
    kernel.realtime = true;
    rtirq.enable = true;
    rtirq.highList = "snd_usb_audio";
  };

  #BOOTLOADER
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  #HOSTNAME
  networking.hostName = "nixos";

  #NETWORKING
  networking.networkmanager.enable = true;

  #TIEMPO
  time.timeZone = "America/Santiago";

  #UTF-8
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CL.UTF-8";
    LC_IDENTIFICATION = "es_CL.UTF-8";
    LC_MEASUREMENT = "es_CL.UTF-8";
    LC_MONETARY = "es_CL.UTF-8";
    LC_NAME = "es_CL.UTF-8";
    LC_NUMERIC = "es_CL.UTF-8";
    LC_PAPER = "es_CL.UTF-8";
    LC_TELEPHONE = "es_CL.UTF-8";
    LC_TIME = "es_CL.UTF-8";
  };

  #X11
  services.xserver.enable = true;

  #HYPRLAND, GNOME, GDM Y LIGHTDM
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  #programs.hyprland.enable = false;

  #KEYMAP X11
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

  #KEYMAP
  console.keyMap = "la-latin1";

  #CUPS / IMPRESION
  services.printing = {
    enable = true;
    drivers = with pkgs; [ cnijfilter2 cups gutenprint cups-filters ];
  };
  #AUDIO
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire."92-bluez-config" = {
      context.properties = {
        bluez5-codecs = ["sbc" "aac" "aptx" "ldac"];
      };
    };
  };

  #NVIDIA
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      glfw vulkan-headers vulkan-loader vulkan-tools
    ];
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;    
  };
  hardware.nvidia.prime = { #INTELXNVIDIA
  sync.enable = true;
    #BUSES
    intelBusId = "PCI:0:2:0"; 
    nvidiaBusId = "PCI:2:0:0";
  };
  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia.force_wayland=1"
  ];

  #USER
  users.users.sintaxis = {
    isNormalUser = true;
    description = "sintaxis";
    extraGroups = ["virt-manager" "virt-viewer" "networkmanager" "wheel" "libvirtd" "qemu_kvm"
                  "kvmtool" "qemu-user" "qemu" "virtualisation" "virbr0" ];
    packages = with pkgs; [
    ];
  };

  #FIREFOX
  programs.firefox.enable = true;

  #DOCKER
  virtualisation.docker = {
    enable = true;
  };
  users.extraGroups.docker.members = ["sintaxis"];

  #PERMITIR UNFREE SOFTWARE
  nixpkgs.config.allowUnfree = true;

  #PERMITIR FLAKES
  nix.settings.experimental-features = ["nix-command" "flakes"];

  #NUR
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz"){
      inherit pkgs;
    };
  };

  #PAQUETES
  environment.systemPackages = with pkgs; [
    nixd #nix
    nur.repos.nltch.spotify-adblock #NUR
    xml2 xmlformat
    git fish neovim vim zed-editor kitty obsidian prettierd notion #editor
    cava neofetch osu-lazer osu-lazer-bin vesktop gnome-menus spotify #weas
    docker-compose docker docker-compose-language-service #docker
    lua-language-server lua #lua
    nodejs_23 yarn npm-check yarn2nix javascript-typescript-langserver typescript typescript-language-server #nodeJS
    gnucobol #COBOL
    rustc rust-analyzer rustup #RUST
    gcc cmake clang clang-tools gnumake gdb boost adolc cccc #C/C++
    (python311.withPackages (ps: with ps; [flask ipython mypy pyright basedpyright pip virtualenv])) #python
    jdk21 gradle jdt-language-server openjdk #java
    eslint javascript-typescript-langserver #JS
    R rstudio rPackages.ggplot2 rPackages.dplyr rPackages.xts #R
    wireshark tor tor-browser virtualbox gns3-gui gutenprint kicad filezilla postgresql go2rtc terraform #INF tools
    terraform-ls terraform-local terraform-inventory terranix qemu-user virt-manager kvmtool virt-viewer #INF tools
    realvnc-vnc-viewer foreman ansible #INF tools
    kotlin kotlin-native kotlin-language-server android-studio android-tools qemu #androidweas
    lshw htop unzip p7zip rar nmap lsof ldacbt qemu_kvm gns3-server usbutils pavucontrol bash lxd-lts killall bun #mngr
    nix-index #mngr
    mpv imv vlc libreoffice libao #media
    swaybg waypaper dolphin swappy waybar dunst xwayland rofi wofi#hypr
    protonup steam-run #steam
    youtube-music tuxguitar reaper audacity lmms yabridge vital calf surge-XT pipewire alsa-utils pulseaudio #music
    blender krita gimp obs-studio wacomtablet #extra tools
  ];  

  #FONTS
  fonts.packages = with pkgs; [
    corefonts
    noto-fonts noto-fonts-emoji noto-fonts-cjk-sans noto-fonts-extra
    liberation_ttf
    fira-code fira-code-symbols fira-math fira-mono 
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  #STEAM
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  #FLATPAK
  services = {
    flatpak.enable = true;
    openssh.enable = true;
  };

  #VIRTUALIZACION
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [ (pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd ];
      };
    };
  };
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "sintaxis" ];
  virtualisation.spiceUSBRedirection.enable = true;
  networking.firewall = {
    allowedTCPPorts = [16509];
    trustedInterfaces = [ "virbr0" ];
  };

  #VERSION
  system.stateVersion = "24.11"; 
}
