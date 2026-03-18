{
  lib,
  stdenvNoCC,
  symlinkJoin,
  tizenSdkVersion,
  tizenSdkDistribution,
  tizenSdkPackages,
  ...
}:
components:
let
  os =
    {
      x86_64-linux = "ubuntu-64";
      i686-linux = "ubuntu-32";
      # XXX: this is prob wrong:
      x86_64-darwin = "macos-64";
      aarch64-darwin = "macos-64";
    }
    .${stdenvNoCC.hostPlatform.system};

  # get from tizenSdkPackages wrappers, fallback to distribution packages for current OS
  getTizenPkgByName = name: tizenSdkPackages.wrapper.${name} or tizenSdkDistribution.${os}.${name};

  all = builtins.genericClosure {
    startSet = map (pkg: {
      key = pkg;
      val = getTizenPkgByName pkg;
    }) components;

    operator =
      item:
      map (pkg: {
        key = pkg;
        val = getTizenPkgByName pkg;
      }) (item.val.tizenDependencies or [ ]);
  };
in
symlinkJoin {
  name = "tizen-sdk-${tizenSdkVersion}";

  paths = map (
    item:
    builtins.trace "evaluating ${item.key} ${if item.val ? unwrapped then "(wrapped)" else ""}" item.val
  ) all;

  postBuild = ''
    # HACK: hard-copy all *.bin symlinks from dist
    # unfortunately, this is required to make bundled bash scripts work correctly
    # find $out -type l -name "*.bin" | while read -r symlink; do
    #   target=$(realpath "$symlink")
    #   rm "$symlink"
    #   cp -rL --reflink=auto "$target" "$symlink"
    # done

    # sdk.info
    mkdir -p "$out/opt/tizen-studio-data"
    cat > "$out/opt/tizen-studio/sdk.info" <<EOF
    TIZEN_SDK_INSTALLED_PATH=$out/opt/tizen-studio
    TIZEN_SDK_DATA_PATH=$out/opt/tizen-studio-data
    EOF

    # sdk.version
    cat > "$out/opt/tizen-studio/sdk.version" <<EOF
    ${tizenSdkVersion}
    EOF
  '';
}
