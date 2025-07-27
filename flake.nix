{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # agenix for encrypting secrets
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # formatter for *.nix files
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ self
    , nixpkgs
    , treefmt-nix
    , agenix
    , ...
    }:
    let
      pkgs =
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
      lib = nixpkgs.lib;
      treefmtEval = treefmt-nix.lib.evalModule (pkgs "x86_64-linux") ./treefmt.nix;
    in
    {
      formatter."x86_64-linux" = treefmtEval.config.build.wrapper;
      checks."x86_64-linux".formatter = treefmtEval.config.build.check self;

      nixosConfigurations = builtins.listToAttrs (
        builtins.map
          (host: {
            name = host.name;
            value = lib.nixosSystem {
              system = host.system;
              pkgs = (pkgs host.system);
              specialArgs = {
                inputs = inputs;
              };
              modules = [
                agenix.nixosModules.default
                {
                  _module.args.agenix = agenix.packages.${host.system}.default;
                }
                ./modules/modules.nix
                ./services/services.nix
              ]
              ++ host.nixosModules;
            };
          })
          (import ./hosts.nix)
      );
      # nixosConfigurations.deep = nixpkgs.lib.nixosSystem {
      #   modules = [ ./configuration.nix ];
      # };
    };
}
