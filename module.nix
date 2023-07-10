{ config
, lib
, pkgs
, ... }:
let
  cfg = config.services.dyndns-nc;

  dyndns-nc = pkgs.callPackage ./package.nix {};

in
{
  options.services.dyndns-nc = with lib; {
    enable = mkEnableOption "Netcup DynDns updater";
    configPath = mkOption {
      type = types.str;
    };
    frequency = mkOption {
      type = types.str;
      description = ''
        How often to trigger an API call.
        NOTE: This string should be a valid value for a systemd
        timer's `OnCalendar` configuration. See
        {manpage}`systemd.timer(5)`
        for more information.
      '';
    };
  };

  config = with lib; mkIf cfg.enable {
    systemd.services.dyndns-nc = {
      script = ''
        set -eu
        ${dyndns-nc}/bin/dyndns-nc --config ${cfg.configPath}
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };

  systemd.timers.dyndns-nc = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = cfg.frequency;
      Unit = "dyndns-nc.service";
    };
  };
}
