{
  runCommand,
  stdenvNoCC,
  javaPackages,
  tizenSdkDistribution,
  ...
}:
let
  inherit (tizenSdkDistribution.ubuntu-64) embedded-java; # (actually unused)
  jdk = javaPackages.compiler.openjdk8;
in
runCommand "embedded-java-${jdk.version}" {
  passthru = embedded-java.passthru // {
    unwrapped = embedded-java;
  };
  meta = {
    inherit (jdk.meta) platforms license;
    # inherit (embedded-java) description;
  };
} ''
  mkdir -p $out/opt/tizen-studio
  ln -s ${jdk} $out/opt/tizen-studio/jdk
''
