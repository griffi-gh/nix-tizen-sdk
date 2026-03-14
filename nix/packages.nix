{ ... }:
{
  perSystem =
    { pkgs, self', ... }:
    {
      packages =
        let
          args = { inherit (self'.legacyPackages) tizen-sdk; };
        in
        {
          sdb = pkgs.callPackage ./packages/sdb.nix args;
        };
    };
}
