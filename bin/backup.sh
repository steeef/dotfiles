#!/usr/bin/env bash

source="${HOME}/"
keep_days=14
rdiff_backup_opts=(
  --exclude-other-filesystems
  --exclude-special-files
  --force
  --no-carbonfile
  --no-hard-links
  --print-statistics
)

destination="${1}"
if [ -z "${destination}" ]; then
  echo "ERROR: You must specify destination"
  echo "USAGE: $(basename "${0}") <destination>"
  exit 2
fi

if ! command -v rdiff-backup >/dev/null 2>&1; then
  echo "ERROR: rdiff-backup must be installed"
  exit 1
fi

read -r -d '' include_list <<EOF
${HOME}/code
${HOME}/.histdb
${HOME}/.zhistory
- **
EOF

if [ -d "${destination}" ]; then
  echo "INFO: Running backup from ${source} to ${destination}"
  rdiff-backup "${rdiff_backup_opts[@]}" --include-globbing-filelist-stdin \
    "${source}" "${destination}" <<<"${include_list}"

  echo "INFO: Removing backups older than ${keep_days} days from ${destination}"
  rdiff-backup "${rdiff_backup_opts[@]}" --force --remove-older-than "${keep_days}D" \
    "${destination}"
else
  echo "ERROR: Destination directory ${destination} not found"
  exit 1
fi
