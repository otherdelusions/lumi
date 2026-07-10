{
  den.aspects.netsec.flclash = {
    nixos =
      { pkgs, ... }:
      {
        boot.kernelModules = [ "tun" ];

        environment.systemPackages = [ pkgs.flclash ];

        security.wrappers.FlClash = {
          owner = "root";
          group = "root";
          capabilities = "cap_net_admin,cap_net_bind_service+ep";
          source = "${pkgs.flclash}/bin/FlClash";
        };
      };
  };
}
