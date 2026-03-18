{
  lib,
  stdenv,
  autoPatchelfHook,
  installShellFiles,
  tizenSdkDistribution,
  ...
}:
let
  inherit (tizenSdkDistribution.ubuntu-64) sdb;
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

  passthru = sdb.passthru // { unwrapped = sdb; };

  meta = {
    description = "Smart Development Bridge for device management";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainCommand = "sdb";
  };
}
