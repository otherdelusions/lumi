{ den, config, ... }:
{
  den.aspects.netsec.includes = [ den.aspects.netsec.zapret ];

  den.aspects.netsec.zapret = {
    nixos = {
      imports = [ config.flake.nixosModules.zapret ];

      netsec.zapret = {
        enable = true;
        addHosts = true;
        strategy = "flow_alt9_nogen";
      };
    };
  };
}
