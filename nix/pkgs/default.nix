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
    })
  ];
}
