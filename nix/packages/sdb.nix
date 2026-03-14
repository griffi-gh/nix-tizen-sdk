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
    # keep tools/ dir for tizen sdk compatibility
    mkdir -p $out/tools
    install -D -m755 $src/tools/{sdb,.sdb-completion.bash} $out/tools/

    mkdir -p $out/bin
    ln -s $out/tools/sdb $out/bin/sdb
    installShellCompletion --bash --name sdb.bash $src/tools/.sdb-completion.bash
  ";

  meta = {
    description = "Smart Development Bridge for device management";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainCommand = "sdb";
  };
}
