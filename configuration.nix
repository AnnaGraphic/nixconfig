# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
	
	# to allo unfree packages like lutris
	nixpkgs.config.allowUnfree = true;

  networking.hostName = "spezi"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
   # keyMap = "us";
     useXkbConfig = true; # use xkbOptions in tty.
   };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "panda";
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "altgr-intl";
  services.syncthing = {
    enable = true;
    user = "panda";
    dataDir = "/home/panda/";
    configDir = "/home/panda/.config/syncthing";
  };
  services.logind = {
    lidSwitch = "lock";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "lock";
  };

	# VM-Sachen
	virtualisation.virtualbox.host.enable = true;


	
	# tells from where to boot after hibernating
	boot.kernelParams = [ 
		"resume=UUID=58e8971d-2a81-424c-8fb0-4ade8c67964b"
];




  # desktop settings
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver.xkbOptions = "eurosign:e";


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

	# Enable bluetooth
  hardware.bluetooth.enable = true;

	# Enable direct rendering 
	hardware.opengl.driSupport32Bit = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    passwordFile = "/etc/secrets/nixospandapassword";
  };
  users.users.panda = {
    isNormalUser = true;
    passwordFile = "/etc/secrets/nixospandapassword";
    extraGroups = [ 
      "wheel"  # Enable ‘sudo’ for the user.
      "audio"
      "video"
      "networkmanager"
			"vboxusers"
    ];
    
    packages = [
      pkgs.firefox
      pkgs.alacritty
      pkgs.vscodium
      pkgs.brave
      pkgs.joplin
      pkgs.libreoffice-qt
			pkgs.lutris
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    (pkgs.vim_configurable.customize {
      name = "vim";
      vimrcConfig.customRC = ''
       set tabstop=2
    '';
    })
    pkgs.wget
    pkgs.git
    pkgs.weechat
    pkgs.mosh # mobile shell
    pkgs.libsForQt5.ark
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.bash = {
    interactiveShellInit = /* sh */ ''
      HISTCONTROL='erasedups:ignorespace'
      HISTSIZE=900001
      HISTFILESIZE=$HISTSIZE
    '';
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # services.tlp.enable = true; # for bluethooth etc # conflicts with services.power-profiles-demon

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?


}



