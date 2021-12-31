{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  networking.hostName = "draper";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    "user" = {
      device = "/dev/disk/by-uuid/0e8169a6-a23d-4651-9042-3b5d08f2679e";
    };
  };

  fileSystems."/".options = ["noatime"];
  fileSystems."/boot".options = ["noatime"];
  fileSystems."/home".options = ["noatime"];
  fileSystems."/nix".options = ["noatime"];

  # Set your time zone.
  time.timeZone = "Canada/Pacific";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  
  i18n.inputMethod.enabled = "ibus";
  i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [
    anthy hangul libpinyin m17n mozc table table-others
  ];
 
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.edd = {
	  isNormalUser = true;
	  extraGroups = [ "wheel" ];
  };

  home-manager.users.edd = {pkgs, ... }: {
	  home.packages = [ pkgs.emacs pkgs.firefox ];
	  programs.bash.enable = true;
  };

  environment.systemPackages = with pkgs; [
    awscli2    
    git
    home-manager
    links
    mr
    playerctl
    vim
    wget
  ];

  fonts = {
      fontDir.enable = true;
      fonts = with pkgs; [
        corefonts
        fira-code
        fira-mono
        inconsolata
        terminus_font
        dejavu_fonts
        font-awesome-ttf
        ubuntu_font_family
        source-code-pro
        source-sans-pro
        source-serif-pro
        ipafont
        kochi-substitute
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
      ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
	  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
		  inherit pkgs;
	  };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.keybase.enable = true;
  services.consul.enable = true;
  services.consul = {
    extraConfig = {
      ui_config.enabled = true;
      retry_join = ["gusting.node.consul"];
      datacenter = "edd";
    };
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="5401", ATTR{power/wakeup}="enabled", ATTR{driver/3-7.4/power/wakeup}="enabled"    
  '';


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
  system.stateVersion = "21.05"; # Did you read the comment?

  nix.gc.automatic = true;
  nix.gc.dates = "02:00";  
}

