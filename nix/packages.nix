{ ... }:
{
  perSystem =
    { pkgs, self', ... }:
    let
      dist = self'.legacyPackages.tizen-sdk-distribution.official;
      mkAll = args: {
        mkTizenSdk = pkgs.callPackage ./packages/mkTizenSdk.nix args;
        sdb = pkgs.callPackage ./packages/wrapper/sdb.nix args;
        embedded-java = pkgs.callPackage ./packages/wrapper/embedded-java.nix args;
        # sdk-utils = pkgs.callPackage ./packages/wrapper/sdk-utils.nix args;
      };
    in
    {
      legacyPackages = rec {
        # Tizen Studio 5.x
        tizen-studio-5_x = mkAll {
          tizenSdkVersion = "5.6";
          tizenSdkDistribution = dist.Tizen_Studio_5_6;
          tizenSdkPackages = tizen-studio-5_x;
        };

        # Tizen Studio 6.x
        tizen-studio-6_x = mkAll {
          tizenSdkVersion = "6.1.1";
          tizenSdkDistribution = dist.Tizen_Studio_6_1_1;
          tizenSdkPackages = tizen-studio-6_x;
        };

        # Tizen SDK 10.x (latest)
        tizen-sdk-10_x = mkAll {
          tizenSdkPackages = tizen-sdk-10_x;
          tizenSdkDistribution = dist.Tizen_SDK_10_0;
          tizenSdkVersion = "10.0";
        };

        # aliases:
        tizen-sdk = tizen-sdk-10_x;
      };

      packages = {
        sdb = self'.legacyPackages.tizen-sdk.sdb;

        _testing_sdk = self'.legacyPackages.tizen-studio-5_x.mkTizenSdk [
          "COMMON-MANDATORY"
          "sdb"
          "embedded-java"
        ];
      };
    };
}
