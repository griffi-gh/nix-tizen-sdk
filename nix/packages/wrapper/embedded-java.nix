{
  runCommand,
  stdenvNoCC,
  javaPackages,
  ...
}:
let
  jdk = javaPackages.compiler.openjdk8;
in
runCommand "embedded-java-${jdk.version}" {
  passthru.unwrapped = jdk;
} ''
  mkdir -p $out/opt/tizen-studio
  ln -s ${jdk} $out/opt/tizen-studio/jdk
''
