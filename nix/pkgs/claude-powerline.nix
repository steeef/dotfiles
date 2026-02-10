# Claude Powerline - A powerline-style status bar for Claude Code
#
# To update this package:
# 1. Get latest release: curl -s https://api.github.com/repos/Owloops/claude-powerline/releases/latest | jq -r .tag_name
# 2. Update version below (remove 'v' prefix)
# 3. Get source hash: nix-prefetch-url --unpack https://github.com/Owloops/claude-powerline/archive/v<VERSION>.tar.gz
# 4. Convert to SRI: nix hash convert --hash-algo sha256 <hash>
# 5. Set npmDepsHash to fake value: "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
# 6. Run: nix build --no-link .#homeConfigurations.sprice@sp.config.home.packages 2>&1 | grep "got:"
# 7. Update npmDepsHash with the correct hash from error message
# 8. Run: hms
{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:
buildNpmPackage rec {
  pname = "claude-powerline";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "Owloops";
    repo = "claude-powerline";
    rev = "v${version}";
    hash = "sha256-DeNXOYgMq9FcIXLCmFunjBQhO3KGUgoE7L1yPiCAEd4=";
  };

  npmDepsHash = "sha256-4xTN96MCAonXjsArM/oWCYnStqidjpQOsy9f4IJleTs=";

  nativeBuildInputs = [nodejs];

  meta = with lib; {
    description = "A powerline-style status bar for Claude Code";
    homepage = "https://github.com/Owloops/claude-powerline";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
