# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
       <nixos-hardware/microsoft/surface>
       ./hardware-configuration.nix
       (fetchTarball "https://github.com/takagiy/nixos-declarative-fish-plugin-mgr/archive/0.0.5.tar.gz")
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.utf8";
    LC_IDENTIFICATION = "sv_SE.utf8";
    LC_MEASUREMENT = "sv_SE.utf8";
    LC_MONETARY = "sv_SE.utf8";
    LC_NAME = "sv_SE.utf8";
    LC_NUMERIC = "sv_SE.utf8";
    LC_PAPER = "sv_SE.utf8";
    LC_TELEPHONE = "sv_SE.utf8";
    LC_TIME = "sv_SE.utf8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable libinput to handle natural scrolling and clickfinger behavior (no software defined areas) on touchpad
  services.xserver.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
    touchpad.clickMethod = "clickfinger";
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable XMonad
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  # UPower is used by taffybar
  services.upower.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable bluetooth pairing (needed according to nixos wiki)
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable docker virtualization. Needed for using supervisord I think
  virtualisation.docker.enable = true;

  # Add betterlockscreen as a systemd service so the screen gets locked upon sleep/suspend
  systemd.services.betterlockscreen = {
    enable = true;
    description = "Lock screen when going to sleep/suspend";
    unitConfig = {
      Type = "simple";
      Before = [ "sleep.target" "suspend.target" ];
    };
    serviceConfig = {
      User = "deco";
      Type = "simple";
      Environment = "DISPLAY=:0";
      ExecStart = "${pkgs.betterlockscreen}/bin/betterlockscreen -- lock";
      TimeoutSec = "infinity";
      ExecStartPost = "${pkgs.coreutils}/bin/sleep 1";
    };
    wantedBy = [ "sleep.target" "suspend.target" ];
  };

  # Define a user account + default shell. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.fish;
  users.users.deco = {
    isNormalUser = true;
    description = "deco";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
  nix.trustedUsers = [ "root" "deco" ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    google-chrome
    picom
    pciutils
    thefuck
    fzf
    ripgrep
    betterlockscreen
    copyq
    taffybar
  ];
  
  # Workaround https://github.com/taffybar/taffybar/issues/403
  # 1. Causes GDK_PIXBUF_MODULE_FILE to be set in xsession.
  services.xserver.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
  # 2. Generates caches for install icons
  gtk.iconCache.enable = true;

  # Enable Fish shell and add plugins with repo cloned in imports
  programs.fish = {
    enable = true;
    plugins = [
      "jethrokuan/fzf"
      "jethrokuan/z"
      "jhillyerd/plugin-git"
    ];
  };

  # Some known fonts + nice fonts from nerdfonts
  fonts.fonts = with pkgs; [
    noto-fonts
    fira-code
    overpass
    nerdfonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
