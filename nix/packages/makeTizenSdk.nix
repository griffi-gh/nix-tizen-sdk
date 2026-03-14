{
  symlinkJoin,
  writeTextFile,
  tizen-sdk,
  tizen-sdk-version,
}:
components: symlinkJoin {
  name = "tizen-sdk";
  paths = components; #++ [];
  postBuild = ''
    # TODO replace embeeded-java/jdk with nix one

    # sdk.info
    mkdir -p "$out/opt/tizen-studio-data"
    cat > "$out/opt/tizen-studio/sdk.info" <<EOF
    TIZEN_SDK_INSTALLED_PATH=$out/opt/tizen-studio
    TIZEN_SDK_DATA_PATH=$out/opt/tizen-studio-data
    EOF

    # sdk.version
    cat > "$out/opt/tizen-studio/sdk.version" <<EOF
    ${tizen-sdk-version}
    EOF
  '';
}
