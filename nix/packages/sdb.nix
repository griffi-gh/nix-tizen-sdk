{
  lib,
  stdenv,
  autoPatchelfHook,
  installShellFiles,
  tizen-sdk,
}:
let
  inherit (tizen-sdk.distribution.official.Tizen_SDK_10_0.ubuntu-64) sdb;
in
stdenv.mkDerivation {
  pname = "sdb";
  inherit (sdb) version;

  src = sdb;

  nativeBuildInputs = [
    autoPatchelfHook
    installShellFiles
  ];
  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = "
    install -Dm755 $src/tools/sdb $out/bin/sdb
    installShellCompletion --bash --name sdb.bash $src/tools/.sdb-completion.bash

    # keep tools/ directory structure for tizen sdk compatibility
    mkdir -p $out/tools
    ln -s $out/bin/sdb $out/tools/sdb
    ln -s $out/share/bash-completion/completions/sdb.bash $out/tools/.sdb-completion.bash
  ";

  meta = {
    description = "Smart Development Bridge for device management";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainCommand = "sdb";
  };
}
