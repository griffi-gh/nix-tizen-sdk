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
    mkdir -p $out/opt/tizen-studio
    cp -r $src/opt/tizen-studio/* $out/opt/tizen-studio

    # install shell completion, link sdb to bin/
    installShellCompletion --bash --name sdb.bash $src/opt/tizen-studio/tools/.sdb-completion.bash
    mkdir -p $out/bin
    ln -s $out/opt/tizen-studio/tools/sdb $out/bin/sdb
  ";

  meta = {
    description = "Smart Development Bridge for device management";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainCommand = "sdb";
  };
}
