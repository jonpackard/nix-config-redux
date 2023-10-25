# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, inputs, vars, unstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./pihole.nix
      ./homebridge.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "atomnix"; # Define your hostname.

  networking.defaultGateway.address = "10.84.1.1";

  networking.vlans = {
    vlan40 = { id=40; interface="eno1"; };
  };

  #Bridging
  networking.iproute2.enable = true;
  networking.bridges =
  {
    vmnic0 = {
      interfaces = [ "eno1" ];
    };
    vmnic1 = {
      interfaces = [ "eno2" ];
    };
    vmnic2 = {
      interfaces = [ "eno3" ];
    };
    vmnic3 = {
      interfaces = [ "eno4" ];
    };
    vmnic4 = {
      interfaces = [ "eno5" "vlan40" ];
    };
  };

  # IMPORTANT - Do not enable DHCP or assign IP addresses to more than one bridge interface on the same VLAN!
  networking.useDHCP = false; # Disable DHCP on any interface not specified
  #networking.interfaces.vmnic0.useDHCP = true;
  #networking.interfaces.vmnic1.useDHCP = true;
  #networking.interfaces.vmnic2.useDHCP = true;
  #networking.interfaces.vmnic3.useDHCP = true;
  #networking.interfaces.vmnic4.useDHCP = true;

  # Mgmt LAN
  networking.interfaces.vmnic0.ipv4.addresses = [ {
    address = "10.84.1.3";
    prefixLength = 24;
  } ];

  # Home Wi-Fi
  networking.interfaces.vmnic4.ipv4.addresses = [ {
    address = "10.84.40.3";
    prefixLength = 24;
  } ];

  #Enable libvirt
  virtualisation.libvirtd.enable = true;

  #Define bridges libvirt can access
  virtualisation.libvirtd.allowedBridges = [
     "vmnic0"
     "vmnic1"
     "vmnic2"
     "vmnic3"
     "vmnic4"
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/New_York";

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

  # Enable Flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # TO-DO: https://nixos.wiki/wiki/Distributed_build
  # temp workaround for remote build...
  nix.settings.require-sigs = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jonathan = {
    isNormalUser = true;
    description = "Jonathan Packard";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "qemu-libvirtd" "kvm" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    home-manager
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

  # Tailscale VPN
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";
  services.tailscale.package = unstable.tailscale;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
