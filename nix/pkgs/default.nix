final: prev: {
  fgj = final.callPackage ./fgj.nix {};
  hidapitester = final.callPackage ./hidapitester.nix {};
  kubectl = final.callPackage ./kubectl.nix {};
  yt-dlp = prev.yt-dlp.override {deno = final.bun;};

  # Fix pipx 1.8.0 tests failing against packaging>=26.0
  # packaging 26.0 inserts a space in Requirement.__str__ (`pkg @ url`),
  # but pipx 1.8.0 tests hard-code the old `pkg@ url` form.
  # Remove when nixpkgs ships pipx >= 1.9.
  # https://github.com/pypa/packaging/releases/tag/26.0
  pipx = prev.pipx.overrideAttrs (old: {
    disabledTests =
      (old.disabledTests or [])
      ++ [
        "test_fix_package_name"
        "test_parse_specifier_for_metadata"
      ];
  });

  # Fixes below are all for Darwin-specific test/build failures. Gate behind
  # isDarwin: overriding pythonPackagesExtensions rehashes the whole
  # python313Packages fixed point, so applying it unconditionally busts the
  # binary cache for every python3-based package on every platform.
  pythonPackagesExtensions =
    if prev.stdenv.isDarwin
    then
      prev.pythonPackagesExtensions
      ++ [
        (_python-final: python-prev: {
          # Fix uvloop test failure with Python 3.13 on Darwin
          # nixpkgs only disables test_cancel_post_init for Python >= 3.14
          # https://github.com/MagicStack/uvloop/issues/622
          uvloop = python-prev.uvloop.overrideAttrs (old: {
            disabledTestPaths =
              (old.disabledTestPaths or [])
              ++ [
                "tests/test_process.py::TestAsyncio_AIO_Process::test_cancel_post_init"
              ];
          });
          # Fix anyio flaky tests with Python 3.13 on Darwin
          # https://github.com/NixOS/nixpkgs/issues/371079
          anyio = python-prev.anyio.overrideAttrs (old: {
            disabledTests =
              (old.disabledTests or [])
              ++ [
                "test_acquire_cancelled"
                "test_cancel_wait_on_thread"
                "test_single_thread"
                "test_thread_cancelled_and_abandoned"
                "test_run_in_custom_limiter"
              ];
          });
          # Fix curl-cffi hanging tests on Darwin
          # Tests deadlock in pytestCheckPhase with multiprocessing workers
          curl-cffi = python-prev.curl-cffi.overrideAttrs (_old: {
            doCheck = false;
          });
          # Fix jeepney build failure on Darwin
          # dbus-run-session fails because launchd activation is broken after
          # Meson upgrade. Upstream fix: https://github.com/NixOS/nixpkgs/pull/485980
          jeepney = python-prev.jeepney.overrideAttrs (old: {
            doInstallCheck = false;
            pythonImportsCheck =
              builtins.filter (m: m != "jeepney.io.trio") (old.pythonImportsCheck or []);
          });
        })
      ]
    else prev.pythonPackagesExtensions;
}
