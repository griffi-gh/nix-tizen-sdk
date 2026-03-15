{ ... }:
{
  perSystem =
    { pkgs, self', ... }:
    let
      dist = self'.legacyPackages.tizen-sdk-distribution.official;
    in
    {
      legacyPackages = rec {
        # Tizen SDK 10.x (latest)
        tizen-sdk-10_x =
          let
            args = {
              tizenSdkPackages = tizen-sdk-10_x;
              tizenSdkDistribution = dist.Tizen_SDK_10_0;
              tizenSdkVersion = "10.0";
            };
          in
          {
            mkTizenSdk = pkgs.callPackage ./packages/mkTizenSdk.nix args;
            sdb = pkgs.callPackage ./packages/sdb.nix args;
          };

        # Tizen Studio 6.x
        tizen-studio-6_x =
          let
            args = {
              tizenSdkVersion = "6.1";
              tizenSdkDistribution = dist.Tizen_Studio_6_1;
              tizenSdkPackages = tizen-studio-6_x;
            };
          in
          {
            mkTizenSdk = pkgs.callPackage ./packages/mkTizenSdk.nix args;
            sdb = pkgs.callPackage ./packages/sdb.nix args;
          };

        # Tizen Studio 5.x
        tizen-studio-5_x =
          let
            args = {
              tizenSdkVersion = "5.6";
              tizenSdkDistribution = dist.Tizen_Studio_5_6;
              tizenSdkPackages = tizen-studio-5_x;
            };
          in
          {
            mkTizenSdk = pkgs.callPackage ./packages/mkTizenSdk.nix args;
            sdb = pkgs.callPackage ./packages/sdb.nix args;
          };

        # aliases:
        tizen-sdk = tizen-sdk-10_x;
      };

      packages = {
        sdb = self'.legacyPackages.tizen-sdk.sdb;

        _testing_sdk = self'.legacyPackages.tizen-studio-5_x.mkTizenSdk [
          "COMMON-MANDATORY"
          "sdb"
        ];
      };
    };
}
