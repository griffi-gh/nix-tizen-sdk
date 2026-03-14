{ ... }:
{
  perSystem =
    { pkgs, self', ... }:
    let
      dist = self'.legacyPackages.tizen-sdk-distribution.official;
    in
    {
      legacyPackages =
        {
          tizen-sdk10 = let
            args = {
              tizen-sdk = dist.Tizen_SDK_10_0;
              tizen-sdk-version = "10.0";
            };
          in {
            makeTizenSdk = pkgs.callPackage ./packages/makeTizenSdk.nix args;
            sdb = pkgs.callPackage ./packages/sdb.nix args;
          };
        };

      packages = {
        sdb = self'.legacyPackages.tizen-sdk10.sdb;
      };
    };
}
