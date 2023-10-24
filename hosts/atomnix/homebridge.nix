{ lib, config, pkgs, inputs, vars, unstable, ... }:

{

  # Homebridge
  # Ref: https://github.com/homebridge/homebridge/wiki/Install-Homebridge-on-Docker
  docker-containers.homebridge = {
    image = "homebridge/homebridge:latest";
    volumes = [
      "homebridge:/homebridge"
    ];
    extraDockerOptions = [
      "--network=host"
    ];
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8581 51293 ];
  networking.firewall.allowedUDPPorts = [ 51293 ];

}
