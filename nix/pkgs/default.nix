final: prev: {
  claude-powerline = final.callPackage ./claude-powerline.nix { };
  hidapitester = final.callPackage ./hidapitester.nix { };
  kubectl = final.callPackage ./kubectl.nix { };

  # Fix uvloop test failure with Python 3.13 on Darwin
  # nixpkgs only disables test_cancel_post_init for Python >= 3.14
  # https://github.com/MagicStack/uvloop/issues/622
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (python-final: python-prev: {
      uvloop = python-prev.uvloop.overrideAttrs (old: {
        disabledTestPaths = (old.disabledTestPaths or [ ]) ++ [
          "tests/test_process.py::TestAsyncio_AIO_Process::test_cancel_post_init"
        ];
      });
      # Fix anyio flaky tests with Python 3.13 on Darwin
      # https://github.com/NixOS/nixpkgs/issues/371079
      anyio = python-prev.anyio.overrideAttrs (old: {
        disabledTests = (old.disabledTests or [ ]) ++ [
          "test_acquire_cancelled"
          "test_cancel_wait_on_thread"
          "test_single_thread"
          "test_thread_cancelled_and_abandoned"
        ];
      });
      # Fix curl-cffi hanging tests on Darwin
      # Tests deadlock in pytestCheckPhase with multiprocessing workers
      curl-cffi = python-prev.curl-cffi.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];
}
