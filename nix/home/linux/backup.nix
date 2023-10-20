{ config, pkgs, ... }: {
  systemd.user.services."backup-alpha" = {
    Unit = {
      Description = "Backup Alpha";
      StartLimitIntervalSec = 120;
      StartLimitBurst = 2;
    };

    Service = {
      Type = "simple";
      Nice = 19;
      IOSchedulingClass = "idle";
      ExecStart = ''
        ${pkgs.rsnapshot}/bin/rsnapshot -v -c ${config.home.homeDirectory}/.rsnapshot.conf alpha
      '';
      Restart = "on-failure";
      RestartSec = 60;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.services."backup-beta" = {
    Unit = {
      Description = "Backup Beta";
      StartLimitIntervalSec = 120;
      StartLimitBurst = 2;
    };

    Service = {
      Type = "simple";
      Nice = 19;
      IOSchedulingClass = "idle";
      ExecStart = ''
        ${pkgs.rsnapshot}/bin/rsnapshot -v -c ${config.home.homeDirectory}/.rsnapshot.conf beta
      '';
      Restart = "on-failure";
      RestartSec = 60;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.services."backup-gamma" = {
    Unit = {
      Description = "Backup Gamma";
      StartLimitIntervalSec = 120;
      StartLimitBurst = 2;
    };

    Service = {
      Type = "simple";
      Nice = 19;
      IOSchedulingClass = "idle";
      ExecStart = ''
        ${pkgs.rsnapshot}/bin/rsnapshot -v -c ${config.home.homeDirectory}/.rsnapshot.conf gamma
      '';
      Restart = "on-failure";
      RestartSec = 60;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
  systemd.user.timers."backup-alpha" = {
    Unit = {
      Description = "Backup Alpha timer";
    };

    Timer = {
      OnCalendar = "00/3:17";
      RandomizedDelaySec = 60;
      Persistent = true;
      Unit = "backup-alpha.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  systemd.user.timers."backup-beta" = {
    Unit = {
      Description = "Backup Beta timer";
    };

    Timer = {
      OnCalendar = "17:09:00";
      RandomizedDelaySec = 60;
      Persistent = true;
      Unit = "backup-beta.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  systemd.user.timers."backup-gamma" = {
    Unit = {
      Description = "Backup Gamma timer";
    };

    Timer = {
      OnCalendar = "Sat 13:27:00";
      RandomizedDelaySec = 60;
      Persistent = true;
      Unit = "backup-gamma.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

}
