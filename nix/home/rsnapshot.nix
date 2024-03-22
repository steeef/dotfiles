{ config, pkgs, ... }: {
  home.file.".rsnapshot.conf".source = pkgs.writeText "rsnapshot.conf" ''
    config_version	1.2
    snapshot_root		${config.home.homeDirectory}/remote/backup/
    no_create_root	1

    cmd_cp		${pkgs.coreutils}/bin/cp
    cmd_du		${pkgs.coreutils}/bin/du
    cmd_rm		${pkgs.coreutils}/bin/rm
    cmd_rsync	${pkgs.rsync}/bin/rsync

    retain	alpha	6
    retain	beta	7
    retain	gamma	4

    verbose		2
    lockfile	${config.home.homeDirectory}/.rsnapshot.pid

    link_dest	1
    rsync_short_args	-a
    rsync_long_args		--delete --verbose --numeric-ids --relative --delete-excluded --no-perms --no-owner --no-group --no-specials --no-devices

    one_fs	1

    exclude	".direnv/"
    exclude	".mypy_cache/"
    exclude	".terraform/"
    exclude	".venv*/"

    backup	${config.home.homeDirectory}/code/	localhost/
    backup	${config.home.homeDirectory}/.histdb/	localhost/
    backup	${config.home.homeDirectory}/.zhistory	localhost/
  '';
}
