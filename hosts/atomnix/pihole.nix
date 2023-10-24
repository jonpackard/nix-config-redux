{ lib, config, pkgs, inputs, vars, unstable, ... }:

{

  # pihole docker container (DNS server with ad and tracker blocking)
  # Ref: https://github.com/NixOS/nixpkgs/issues/61617#issuecomment-500793160
  docker-containers.pihole = {
    image = "pihole/pihole:latest";
    ports = [
      "53:53/tcp"
      "53:53/udp"
      "3080:80"
      "30443:443"
    ];
    volumes = [
      "/var/lib/pihole/:/etc/pihole/"
      "/var/lib/dnsmasq.d:/etc/dnsmasq.d/"
    ];
    extraDockerOptions = [
      "--cap-add=NET_ADMIN"
      "--dns=127.0.0.1"
      "--dns=1.1.1.1"
    ];
    workdir = "/var/lib/pihole/";
  };

}
