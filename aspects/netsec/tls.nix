{ den, ... }:
{
  den.aspects.netsec.includes = [ den.aspects.netsec.tls ];

  den.aspects.netsec.tls.nixos =
    { pkgs, ... }:
    let
      # this should fix rebuild timeouts
      opensslConfig = pkgs.writeText "openssl-network-compat.cnf" ''
        .include ${pkgs.openssl.out}/etc/ssl/openssl.cnf

        [openssl_init]
        ssl_conf = lumi_ssl

        [lumi_ssl]
        system_default = lumi_tls

        [lumi_tls]
        Groups = ?X25519MLKEM768:DEFAULT
      '';
    in
    {
      environment.etc."ssl/openssl.cnf".source = opensslConfig;
      environment.sessionVariables.OPENSSL_CONF = "/etc/ssl/openssl.cnf"; # pass to sudo
      systemd.services.nix-daemon.environment.OPENSSL_CONF = opensslConfig; # pass to daemon
    };
}
