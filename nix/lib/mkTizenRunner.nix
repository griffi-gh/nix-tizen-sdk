{
  writeShellScript,
  javaPackages,

  runTarget,
  ...
}:
let
  jdk = javaPackages.compiler.openjdk8;
in
writeShellScript "tizen-sdk-component.sh" ''
  export JAVA_EXEC="${jdk}/bin/java"
  ${jdk}/bin/java -jar ${runTarget}
''
