{ config, pkgs, ... }:
{
  imports = [./per-host.nix ./gusting-hardware.nix];

  perHost = {
    enable = true;
    hostName = "gusting";
  };

  boot.initrd.kernelModules = [ "usb_storage" ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  fileSystems."/".options = ["noatime"];
  fileSystems."/srv" = {
    device = "/dev/mapper/external";
    options = ["nofail"];
    neededForBoot = false;
  };
  environment.etc."crypttab".text = ''
    external   /dev/sda1   /boot/hdd.key luks
  '';

  # Set your time zone.
  time.timeZone = "Canada/Pacific";

  i18n.defaultLocale = "en_CA.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.edd = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = [];
     openssh.authorizedKeys.keys = [
"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSDjnFfiYKLPC+ABw1Z48C4gRHlvXmCtaiN7wJ0WnKaVEB40o1y7sufwwBY4jc9RxvMZCELHp4IUp7Y9YWsFlA2nj5FbTmF+wiOhx1Edj50to4HxKojkzS+0RJC7LDP2qWMN5A2hiA9OxneY2Ek8Ta4wgPLoFp8rSH7O/Ny6SCf1TG9t6flgSXbhmg5Bp770jTiz/1JL6wGbcqDH0tSxgc2ITY3chq6/SZ7u02WF7/Xua4Rrag8orTkJaBNswANaW6Xs8TXaV+aQEIBKYK1MTMtvBt3cCrF9AE86zPB7AHBoJ73wSu76zGW/qVoIYEYFITNb2YQ+Q/Sb4/hv92Z/ihA18w250qPP9MC5a689mkWPdtkQSsvaujBNvGUT9525DnWdBVi5KW45q/tHmB83ZRMO2e4G+P4sPbqTd09kQkItqHC7B7F2kukuNLQk84jVvVxOi2xDvW9ReLb7ozKDqOf4pDg8Hm0+f6wJe1xU4soPRPRyGOVqh7fb6+PTkf82k= edd@draper"
];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     cryptsetup
     emacs
     vim 
     wget
     git
     libraspberrypi
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
  services.openssh.enable = true;

  services.jellyfin = {
    enable = true;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 8096 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

