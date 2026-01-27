{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  patchelf,
}:
# To update:
# 1. Set `version` to the new release version
# 2. Update all four SRI hashes by running:
#      VERSION="<new-version>"
#      BASE="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"
#      for plat in linux-x64 linux-arm64 darwin-x64 darwin-arm64; do
#        echo "$plat:"
#        nix-prefetch-url --type sha256 "$BASE/$VERSION/$plat/claude" 2>/dev/null \
#          | xargs nix hash convert --from nix32 --to sri --hash-algo sha256
#      done
# 3. Run `hms` to build and verify
let
  version = "2.1.19";
  baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";

  platformMap = {
    x86_64-linux = {
      cdnPlatform = "linux-x64";
      hash = "sha256-Tiocc4cezzsTM3a1fe0DMzp6Y4fy0qOmJ5u5Cgf3qUQ=";
    };
    aarch64-linux = {
      cdnPlatform = "linux-arm64";
      hash = "sha256-jEthskynYNb3qi8ZcnFj0SLp/Qw86R8QaiG2kYp7G7s=";
    };
    x86_64-darwin = {
      cdnPlatform = "darwin-x64";
      hash = "sha256-viZrOpUvSD2DWK0UHir+ZhFwOGUG9Hnq2ZIxnk/cOKw=";
    };
    aarch64-darwin = {
      cdnPlatform = "darwin-arm64";
      hash = "sha256-04asj20UefhdMfNpQhyCQTXBAknDIIcBfQWl9CiFLEE=";
    };
  };

  platform = platformMap.${stdenv.hostPlatform.system}
    or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
assert !stdenv.hostPlatform.isMusl;
stdenv.mkDerivation {
  pname = "claude-code";
  inherit version;

  src = fetchurl {
    url = "${baseUrl}/${version}/${platform.cdnPlatform}/claude";
    hash = platform.hash;
  };

  dontUnpack = true;
  dontPatchELF = true; # automatic patchelf --shrink-rpath corrupts Bun payload
  dontStrip = true; # strip corrupts the Bun embedded payload trailer

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    patchelf
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/claude
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" $out/bin/claude
    # Verify Bun trailer survived patching
    if ! tail -c 20 $out/bin/claude | grep -q "Bun!"; then
      echo "ERROR: Bun trailer corrupted by patchelf"
      exit 1
    fi
  '' + ''
    # https://github.com/anthropics/claude-code/issues/8523
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/cl/claude-code/package.nix
    wrapProgram $out/bin/claude \
      --set DISABLE_INSTALLATION_CHECKS 1 \
      --set DISABLE_AUTOUPDATER 1
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    output=$(HOME=$TMPDIR $out/bin/claude --version 2>&1)
    echo "$output"
    echo "$output" | grep -q "${version}"
  '';

  meta = {
    description = "Anthropic's CLI for Claude AI";
    homepage = "https://docs.anthropic.com/en/docs/claude-code";
    license = lib.licenses.unfree;
    mainProgram = "claude";
    platforms = builtins.attrNames platformMap;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
