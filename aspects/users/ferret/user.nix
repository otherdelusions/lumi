{ den, ... }:
{
  den.aspects.ferret = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "fish")
      den.aspects.dev
    ];

    homeManager = {
      programs.home-manager.enable = true;
    };

    provides.to-hosts = {
      nixos = {
        security.nix-secrets = {
          identityPaths = [
            "/home/ferret/keys.txt"
          ];
          recipientAliases = {
            ferret = "age1g6flkq5k0kqxy2y7fdk5ttpzjp6t0d7yz47h0p2mnvuu7we8x3fsa4m5m0";
          };

          secrets = {
            "ssh_keys/to_github" = {
              recipients = [ "ferret" ];
              owner = "ferret";
            };
            "ssh_keys/to_ash" = {
              recipients = [ "ferret" ];
              owner = "ferret";
            };
          };
        };
      };
    };
  };
}
