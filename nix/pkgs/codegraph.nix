# CodeGraph — pre-indexed local code knowledge graph exposed to agents over MCP.
# Upstream ships self-contained prebuilt bundles (a vendored Node runtime + a JS
# app + a POSIX-sh launcher) per platform on GitHub Releases; there is no source
# build. We install the bundle verbatim and symlink its launcher, which resolves
# symlinks back to the bundle dir itself (so `$out/bin/codegraph` just works).
# macOS-only for now: that's where the Claude worktree workflow runs, and the
# Linux bundle's vendored Node would need autoPatchelfHook (unverified).
#
# Updating to a new release — do NOT run `codegraph upgrade` (it targets the
# installer's ~/.local/bin layout and no-ops against the read-only nix store):
#   1. Prefetch both Darwin hashes for the new tag:
#        V=1.3.0   # new release tag, without the leading "v"
#        for a in darwin-arm64 darwin-x64; do \
#          nix-prefetch-url --type sha256 \
#            "https://github.com/colbymchenry/codegraph/releases/download/v$V/codegraph-$a.tar.gz"; \
#        done
#   2. Set `version` below and paste the two printed hashes into `sources`.
#   3. `hms` — the MCP command follows automatically (it's ${pkgs.codegraph}/bin).
# Worktree indexes are unaffected by a bump; only a DB-schema change needs a
# re-`codegraph init` (lazy/per-worktree anyway).
{
  lib,
  stdenv,
  fetchurl,
}: let
  version = "1.2.0";
  base = "https://github.com/colbymchenry/codegraph/releases/download/v${version}";
  sources = {
    aarch64-darwin = {
      arch = "darwin-arm64";
      sha256 = "0k85jqsq58x9n9dw1a5fihfqik6dp075d61agykbjsj4abffr8w3";
    };
    x86_64-darwin = {
      arch = "darwin-x64";
      sha256 = "1n4vdshw7b3s6ilip9fw5rm4h39yklq30yqys2xghrd0paczz5vg";
    };
  };
  src' =
    sources.${stdenv.hostPlatform.system}
    or (throw "codegraph: unsupported platform ${stdenv.hostPlatform.system}");
in
  stdenv.mkDerivation {
    pname = "codegraph";
    inherit version;

    src = fetchurl {
      url = "${base}/codegraph-${src'.arch}.tar.gz";
      inherit (src') sha256;
    };

    # Prebuilt Mach-O + JS: nothing to configure/build, and stripping would
    # corrupt the signed vendored `node` binary.
    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;

    # Tarball unpacks to codegraph-${arch}/ (bin/, lib/, node); install it whole
    # and expose the launcher, which readlink-resolves back to the bundle dir.
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/libexec/codegraph" "$out/bin"
      cp -R . "$out/libexec/codegraph/"
      ln -s "$out/libexec/codegraph/bin/codegraph" "$out/bin/codegraph"
      runHook postInstall
    '';

    meta = {
      description = "Pre-indexed local code knowledge graph for AI agents (MCP)";
      homepage = "https://github.com/colbymchenry/codegraph";
      license = lib.licenses.mit;
      mainProgram = "codegraph";
      platforms = ["aarch64-darwin" "x86_64-darwin"];
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
