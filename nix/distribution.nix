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
              in
              lib.listToAttrs (
                map (
                  package:
                  let
                    pname = lib.replaceString "." "_" package.package;
                  in
                  {
                    name = pname;
                    value =
                      let
                        inherit (pkgs) stdenvNoCC fetchurl unzip;
                      in
                      stdenvNoCC.mkDerivation {
                        # TODO: respect dependencies
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
                          mkdir -p $out/opt/tizen-studio
                          mv data/* $out/opt/tizen-studio/
                        '';
                        meta = {
                          inherit (package) description; # (prob should be longDescription)
                          license = lib.licenses.unfree;
                          sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
                          homepage = "https://developer.tizen.org/development/tizen-studio/download/";
                        };
                      };
                  }
                ) packages
              )
            ) snapshot.packages;
          }) distribution.snapshots
        ) index;
    };
}
