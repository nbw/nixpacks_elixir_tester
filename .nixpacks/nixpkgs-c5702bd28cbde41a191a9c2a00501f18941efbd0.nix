{ }:

let pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/c5702bd28cbde41a191a9c2a00501f18941efbd0.tar.gz") { overlays = [  ]; };
in with pkgs;
  let
    APPEND_LIBRARY_PATH = "${lib.makeLibraryPath [ stdenv.cc.cc.lib ] }";
    myLibraries = writeText "libraries" ''
      export LD_LIBRARY_PATH="${APPEND_LIBRARY_PATH}:$LD_LIBRARY_PATH"
      
    '';
  in
    buildEnv {
      name = "c5702bd28cbde41a191a9c2a00501f18941efbd0-env";
      paths = [
        (runCommand "c5702bd28cbde41a191a9c2a00501f18941efbd0-env" { } ''
          mkdir -p $out/etc/profile.d
          cp ${myLibraries} $out/etc/profile.d/c5702bd28cbde41a191a9c2a00501f18941efbd0-env.sh
        '')
        elixir_1_14 gcc
      ];
    }
