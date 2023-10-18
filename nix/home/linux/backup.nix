{ config, pkgs, ... }: {
  systemd.user.services."backup@" = {
    Unit = {
      Description = "Backup %I";
      StartLimitIntervalSec = 120;
      tTartLimitBurst = 2;
    };

    Service = {
      Type = "simple";
      Nice = 19;
      IOSchedulingClass = "idle";
      ExecStart = ''
        ${pkgs.rsnapshot}/bin/rsnapshot -c ${config.home.homeDirectory}/.rsnapshot.conf %I
      '';
      Restart = "on-failure";
      RestartSec = 60;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.services."backup-alpha.timer" = {
    Unit = {
      Description = "Backup Alpha timer";
    };

    Timer = {
      OnCalendar = "00/3:17";
      RandomizedDelaySec = 60;
      Persistent = true;
      Unit = "backup@alpha.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  systemd.user.services."backup-beta.timer" = {
    Unit = {
      Description = "Backup Beta timer";
    };

    Timer = {
      OnCalendar = "17:09:00";
      RandomizedDelaySec = 60;
      Persistent = true;
      Unit = "backup@beta.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  systemd.user.services."backup-gamma.timer" = {
    Unit = {
      Description = "Backup Gamma timer";
    };

    Timer = {
      OnCalendar = "Sat 13:27:00";
      RandomizedDelaySec = 60;
      Persistent = true;
      Unit = "backup@gamma.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

}
