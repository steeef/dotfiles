# rkvr — safe file archival/removal tool (tar.gz-archives targets before
# deleting, recoverable via `rkvr rcvr`, listed via `rkvr ls-rmrf`).
# Upstream ships no Cargo.lock, so we generate and vendor our own
# (rkvr-Cargo.lock, alongside this file) rather than relying on one from src.
#
# Bumping version: update `version`/`rev` below, `nix-prefetch-url --unpack
# https://github.com/scottidler/rkvr/archive/<rev>.tar.gz` for the new
# `sha256`, then regenerate rkvr-Cargo.lock: clone the repo at `<rev>`, run
# `cargo generate-lockfile`, and copy the resulting Cargo.lock over
# rkvr-Cargo.lock.
{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  libiconv,
}:
rustPlatform.buildRustPackage rec {
  pname = "rkvr";
  version = "0.1.22";

  src = fetchFromGitHub {
    owner = "scottidler";
    repo = "rkvr";
    rev = "02049d31328e734646db91efbffa5e49dab6ba65";
    sha256 = "01jaq27cj0a9xf5d3njg8qkms10ps01xrghvi8aa7skzdwda1qmj";
  };

  cargoLock = {
    lockFile = ./rkvr-Cargo.lock;
  };
  postPatch = ''
    cp ${./rkvr-Cargo.lock} Cargo.lock
  '';

  # Unit tests shell out to `eza` (https://github.com/eza-community/eza),
  # which isn't available in the nix build sandbox and isn't needed to
  # produce a working binary.
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [libiconv];

  meta = {
    description = "A safe file archival and removal tool";
    homepage = "https://github.com/scottidler/rkvr";
    license = lib.licenses.mit;
    mainProgram = "rkvr";
  };
}
