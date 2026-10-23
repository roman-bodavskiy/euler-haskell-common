{
  inputs = {
    common.url = "github:nammayatri/common?ref=ghc-98-upgrade";
  };

  outputs = inputs:
    inputs.common.lib.mkFlake { inherit inputs; } {
      perSystem = { self', pkgs, config, ... }: {

        haskellProjects.default = let fs = pkgs.lib.fileset; in {

          projectRoot = builtins.toString (fs.toSource {
            root = ./.;
            fileset = fs.unions [
              ./src
              ./test
              ./benchmark
              ./juspay-extra.cabal
            ];
          });

          autoWire = [ "packages" ];
          packages = {
            # Dependencies
          };
        };

        packages.default = self'.packages.juspay-extra;

        devShells.default = pkgs.mkShell {
          name = "euler-haskell-common-devshell";
          inputsFrom = [
            config.haskellProjects.default.outputs.devShell
            # FIXME This will change pre-commit formatting. For now used 'git commit --no-verify' option
            config.pre-commit.devShell
            config.flake-root.devShell
          ];
        };
      };
    };
}
