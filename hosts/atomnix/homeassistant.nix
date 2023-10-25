{ lib, config, pkgs, inputs, vars, unstable, ... }:

{

  # Home Assistant
  # Ref: https://www.home-assistant.io/installation/linux
  docker-containers.homeassistant = {
    image = "homeassistant/home-assistant";
    volumes = [
      "homeassistant:/config"
    ];
    extraDockerOptions = [
      "--network=host"
      "--dns=1.1.1.1"
      "--dns=1.0.0.1"
      "--privileged"
      "-e TZ=America/New_York
    ];
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8123 ];
  networking.firewall.allowedUDPPorts = [ 8123 ];

}
