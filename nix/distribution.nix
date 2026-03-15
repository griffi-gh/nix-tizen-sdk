{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      inherit (pkgs) lib;
    in
    {
      legacyPackages.tizen-sdk-distribution =
        let
          index = lib.importJSON ../data/index.json;
        in
        lib.mapAttrs (
          distribution_name: distribution:
          lib.mapAttrs' (snapshot_name: snapshot: {
            name = lib.replaceString "." "_" snapshot_name;
            value = lib.mapAttrs (
              os: object_path:
              let
                packages = lib.importJSON ../${object_path};
                pkgSet = lib.listToAttrs (
                  map (
                    package:
                    let
                      normalizePkgName = pkg: lib.replaceString "." "_" pkg;
                      pname = normalizePkgName package.package;
                    in
                    {
                      name = pname;
                      value =
                        let
                          inherit (pkgs) stdenvNoCC fetchurl unzip;
                        in
                        stdenvNoCC.mkDerivation {
                          inherit pname;
                          inherit (package) version;

                          src = fetchurl {
                            url = "https://download.tizen.org/sdk/tizenstudio/${distribution_name}${package.path}";
                            inherit (package) sha256;
                          };
                          nativeBuildInputs = [ unzip ];
                          unpackPhase = ''
                            unzip $src
                          '';
                          installPhase = ''
                            mkdir -p $out/opt/
                            mv data $out/opt/tizen-studio
                          '';

                          passthru = {
                            isTizenDistPackage = true;
                            tizenDependencies =
                              let
                                rawDeps = lib.splitString "," (package.install_dependency or "");
                              in
                              lib.pipe rawDeps [
                                (map (
                                  pkgName:
                                  lib.pipe pkgName [
                                    (lib.splitString "[")
                                    (xs: builtins.elemAt xs 0)
                                    lib.trim
                                    normalizePkgName
                                  ]
                                ))
                                (builtins.filter (pkgName: pkgName != "" && pkgSet ? ${pkgName}))
                                # (map (pkgName: pkgSet.${pkgName}))
                              ];
                            tizenDistribution = distribution_name;
                            tizenSnapshot = snapshot_name;
                            tizenOs = os;
                          };
                          meta = {
                            # TODO: error: attribute 'description' missing
                            # inherit (package) description; # (prob should be longDescription)
                            license = lib.licenses.unfree;
                            sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
                            homepage = "https://developer.tizen.org/development/tizen-studio/download/";
                          };
                        };
                    }
                  ) packages
                );
              in
              pkgSet
            ) snapshot.packages;
          }) distribution.snapshots
        ) index;
    };
}
