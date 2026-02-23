final: prev: {
  claude-powerline = final.callPackage ./claude-powerline.nix {};
  hidapitester = final.callPackage ./hidapitester.nix {};
  kubectl = final.callPackage ./kubectl.nix {};
  yt-dlp = (prev.yt-dlp.override {deno = final.bun;}).overrideAttrs (_old: {
    version = "2026.02.21";
    src = final.fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      tag = "2026.02.21";
      hash = "sha256-r9I/zLyqGPeIzsHsLxJcfnLC3jpuyKMyX1UaMoM08jk=";
    };
  });

  # Fix uvloop test failure with Python 3.13 on Darwin
  # nixpkgs only disables test_cancel_post_init for Python >= 3.14
  # https://github.com/MagicStack/uvloop/issues/622
  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (_python-final: python-prev: {
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
        # Fix aiohttp flaky timing test on Darwin
        # test_regex_performance asserts < 10ms which fails under build load
        aiohttp = python-prev.aiohttp.overrideAttrs (old: {
          disabledTests =
            (old.disabledTests or [])
            ++ [
              "test_regex_performance"
            ];
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
    ];
}
