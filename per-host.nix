{ lib, config, ... }:
with lib;
let
  cfg = config.perHost;  
in {
  options.perHost = {
    enable = mkEnableOption "Use per-host configuration";
    hostName = mkOption {
      type = types.str;
    };
    os = mkOption {
      type = types.str;
      default = "nixos";
      description = "nixos or darwin";
    };
  };

  config = mkIf cfg.enable {
    networking.hostName = cfg.hostName;

    nix.nixPath = [
      "${cfg.os}-config=/etc/${cfg.os}/${cfg.hostName}.nix"
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    environment.variables = {
      HOSTNAME = cfg.hostName;
      NIXOS_CONFIG = "/etc/nixos/${cfg.hostName}.nix";
    };
  };
}
