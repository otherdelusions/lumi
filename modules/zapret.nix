{
  flake.nixosModules.zapret =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    let
      flowsealData = pkgs.fetchFromGitHub {
        owner = "Flowseal";
        repo = "zapret-discord-youtube";
        tag = "1.9.7b";
        hash = "sha256-k81WLuDrvG3zjVf3wVgnUTrpomJbuipGJv3TGX7suqc=";
      };

      strategies =
        let
          flowGoogle = "${flowsealData}/lists/list-google.txt";
          flowEx = "${flowsealData}/lists/list-exclude.txt";
          flowIpEx = "${flowsealData}/lists/ipset-exclude.txt";
          flowIp = "${flowsealData}/lists/ipset-all.txt";

          quicGoogle = "${flowsealData}/bin/quic_initial_www_google_com.bin";
          tlsMax = "${flowsealData}/bin/tls_clienthello_max_ru.bin";
        in
        {
          flow_alt3_nogen = {
            udpPorts = [
              "443"
              "19294:19344"
              "50000:50100"
              "1024:65535"
            ];
            filters = [
              "--filter-udp=443 --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake --dpi-desync-fake-quic=\"${quicGoogle}\" --new"
              "--filter-tcp=443 --hostlist=\"${flowGoogle}\" --ip-id=zero --dpi-desync=fake,hostfakesplit --dpi-desync-fake-tls-mod=rnd,dupsid,sni=www.google.com --dpi-desync-hostfakesplit-mod=host=www.google.com,altorder=1 --dpi-desync-fooling=ts --new"
              "--filter-tcp=80,443 --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake,hostfakesplit --dpi-desync-fake-tls-mod=rnd,dupsid,sni=ya.ru --dpi-desync-hostfakesplit-mod=host=ya.ru,altorder=1 --dpi-desync-fooling=ts --dpi-desync-fake-http=\"${tlsMax}\" --new"
              "--filter-udp=443 --ipset=\"${flowIp}\" --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"${quicGoogle}\" --new"
              "--filter-tcp=80,443,8443 --ipset=\"${flowIp}\" --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake,hostfakesplit --dpi-desync-fake-tls-mod=rnd,dupsid,sni=ya.ru --dpi-desync-hostfakesplit-mod=host=ya.ru,altorder=1 --dpi-desync-fooling=ts --dpi-desync-fake-http=\"${tlsMax}\" --new"
              "--filter-udp=1024-65535 --ipset=\"${flowIp}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake --dpi-desync-repeats=10 --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp=\"${quicGoogle}\" --dpi-desync-cutoff=n4"
            ];
          };
          flow_alt9_nogen = {
            udpPorts = [
              "443"
              "19294:19344"
              "50000:50100"
              "1024:65535"
            ];
            filters = [
              "--filter-udp=443 --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"${quicGoogle}\" --new"
              "--filter-tcp=443 --hostlist=\"${flowGoogle}\" --ip-id=zero --dpi-desync=hostfakesplit --dpi-desync-repeats=4 --dpi-desync-fooling=ts --dpi-desync-hostfakesplit-mod=host=www.google.com --new"
              "--filter-tcp=80,443 --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=hostfakesplit --dpi-desync-repeats=4 --dpi-desync-fooling=ts,md5sig --dpi-desync-hostfakesplit-mod=host=ozon.ru --new"
              "--filter-udp=443 --ipset=\"${flowIp}\" --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"${quicGoogle}\" --new"
              "--filter-tcp=80,443,8443 --ipset=\"${flowIp}\" --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=hostfakesplit --dpi-desync-repeats=4 --dpi-desync-fooling=ts --dpi-desync-hostfakesplit-mod=host=ozon.ru --new"
              "--filter-udp=1024-65535 --ipset=\"${flowIp}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake --dpi-desync-repeats=12 --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp=\"${quicGoogle}\" --dpi-desync-cutoff=n2"
            ];
          };
        };

      cfg = config.netsec.zapret;
    in
    {
      options.netsec.zapret = {
        enable = lib.mkEnableOption "Enable zapret";
        addHosts = lib.mkEnableOption "Add custom entries to /etc/hosts";

        strategy = lib.mkOption {
          type = lib.types.enum (lib.attrNames strategies);
          default = lib.last (lib.attrNames strategies);
          description = "Zapret strategy to use";
        };
      };

      config = lib.mkIf cfg.enable {
        services.zapret = {
          enable = true;
          udpSupport = true;
          inherit (strategies.${cfg.strategy}) udpPorts;
          params = strategies.${cfg.strategy}.filters;
        };

        networking.hostFiles = lib.optional cfg.addHosts "${flowsealData}/.service/hosts";
      };
    };
}
