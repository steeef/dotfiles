{ config, pkgs, ... }: {
  home.file.".rsnapshot.conf".source = pkgs.writeText "rsnapshot.conf" ''
    config_version	1.2
    snapshot_root		${config.home.homeDirectory}/remote/backup/
    no_create_root	1

    cmd_cp		/bin/cp
    cmd_rm		/bin/rm
    cmd_rsync	${pkgs.rsync}/bin/rsync

    retain	alpha	6
    retain	beta	7
    retain	gamma	4

    verbose		2
    lockfile	/run/rsnapshot.pid

    rsync_short_args	-a
    rsync_long_args		--delete --numeric-ids --relative --delete-excluded --no-perms --no-owner --no-group --no-specials --no-devices

    one_fs	1

    exclude	"*"
    include	"${config.home.homeDirectory}/code/"
    include	"${config.home.homeDirectory}/.histdb/"
    include	"${config.home.homeDirectory}/.zhistory"

    backup	${config.home.homeDirectory}/	localhost/
  '';
}
