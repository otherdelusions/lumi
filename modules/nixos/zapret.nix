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
    tag = "1.10.4";
    hash = "sha256-5qKg2BvW4XcjY+Az9ocvwACcfsfBpG4I3Xh6SCPksIM=";
  };

  flowGoogle = "${flowsealData}/lists/list-google.txt";
  flowEx = "${flowsealData}/lists/list-exclude.txt";
  flowIpEx = "${flowsealData}/lists/ipset-exclude.txt";
  flowIp = "${flowsealData}/.service/ipset-service.txt";

  quicGoogle = "${flowsealData}/bin/quic_initial_www_google_com.bin";
  tlsGoogle = "${flowsealData}/bin/tls_clienthello_www_google_com.bin";
  tlsSferum = "${flowsealData}/bin/tls_clienthello_www_sferum_ru.bin";

  stun2 = "${flowsealData}/bin/stun2.bin";

  strategies = {
    s1_any = {
      udpPorts = [ "443" ];
      extraTcpPorts = [ "8443" ];
      filters = [
        "--filter-udp=443 --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"${quicGoogle}\" --new"
        "--filter-tcp=443 --hostlist=\"${flowGoogle}\" --ip-id=zero --dpi-desync=fake,hostfakesplit --dpi-desync-fake-tls-mod=rnd,dupsid,sni=www.google.com --dpi-desync-hostfakesplit-mod=host=www.google.com,altorder=1 --dpi-desync-fooling=ts --new"
        "--filter-tcp=80,443 --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake,hostfakesplit --dpi-desync-fake-tls-mod=rnd,dupsid,sni=ya.ru --dpi-desync-hostfakesplit-mod=host=ya.ru,altorder=1 --dpi-desync-fooling=ts --dpi-desync-fake-http=\"${tlsSferum}\" --new"
        "--filter-tcp=8443 --ipset=\"${flowIp}\" --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake,hostfakesplit --dpi-desync-fake-tls-mod=rnd,dupsid,sni=ya.ru --dpi-desync-hostfakesplit-mod=host=ya.ru,altorder=1 --dpi-desync-fooling=ts --dpi-desync-fake-http=\"${tlsSferum}\""
      ];
    };
    s2_any = {
      udpPorts = [ "443" ];
      extraTcpPorts = [ "8443" ];
      filters = [
        "--filter-udp=443 --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"${quicGoogle}\" --new"
        "--filter-tcp=443 --hostlist=\"${flowGoogle}\" --ip-id=zero --dpi-desync=hostfakesplit --dpi-desync-repeats=4 --dpi-desync-fooling=ts --dpi-desync-hostfakesplit-mod=host=www.google.com --new"
        "--filter-tcp=80,443 --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=hostfakesplit --dpi-desync-repeats=4 --dpi-desync-fooling=ts,md5sig --dpi-desync-hostfakesplit-mod=host=ozon.ru --new"
        "--filter-tcp=8443 --ipset=\"${flowIp}\" --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=hostfakesplit --dpi-desync-repeats=4 --dpi-desync-fooling=ts --dpi-desync-hostfakesplit-mod=host=ozon.ru"
      ];
    };
    s3_any = {
      udpPorts = [ "443" ];
      extraTcpPorts = [ "8443" ];
      filters = [
        "--filter-udp=443 --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=\"${quicGoogle}\" --new"
        "--filter-tcp=443 --hostlist=\"${flowGoogle}\" --ip-id=zero --dpi-desync=fake,multisplit --dpi-desync-split-pos=1 --dpi-desync-split-seqovl=681 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern=\"${tlsGoogle}\" --dpi-desync-fake-tls=\"${tlsGoogle}\" --new"
        "--filter-tcp=80,443 --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=664 --dpi-desync-split-pos=1 --dpi-desync-repeats=8 --dpi-desync-fooling=ts --dpi-desync-split-seqovl-pattern=\"${tlsSferum}\" --dpi-desync-fake-tls=\"${stun2}\" --dpi-desync-fake-tls=\"${tlsSferum}\" --dpi-desync-fake-http=\"${tlsSferum}\" --new"
        "--filter-tcp=8443 --ipset=\"${flowIp}\" --hostlist-exclude=\"${flowEx}\" --ipset-exclude=\"${flowIpEx}\" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=664 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern=\"${tlsSferum}\" --dpi-desync-fake-tls=\"${stun2}\" --dpi-desync-fake-tls=\"${tlsSferum}\" --dpi-desync-fake-http=\"${tlsSferum}\""
      ];
    };
    s4_any = {
      udpPorts = [ "443" ];
      extraTcpPorts = [ ];
      filters = [
        "--filter-tcp=443 --hostlist=\"${flowGoogle}\" --ip-id=zero --dpi-desync=fake,multisplit --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-fake-tls=\"${stun2}\" --dpi-desync-fake-tls=\"${tlsSferum}\" --new"
        "--filter-tcp=80,443 --dpi-desync=multisplit --dpi-desync-split-pos=1 --dpi-desync-split-seqovl=1 --new"
        "--filter-udp=443 --filter-l7=quic --hostlist=\"${flowGoogle}\" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=\"${quicGoogle}\""
      ];
    };
  };

  cfg = config.netsec.zapret;
  strategy = strategies.${cfg.strategy};

  firstPackets = "-m connbytes --connbytes-dir=original --connbytes-mode=packets --connbytes 1:6";
  queue = "-m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num ${toString config.services.zapret.qnum} --queue-bypass";
in
{
  options.netsec.zapret = {
    enable = lib.mkEnableOption "Enable zapret";
    addHosts = lib.mkEnableOption "Add custom entries to /etc/hosts";

    strategy = lib.mkOption {
      type = lib.types.enum (lib.attrNames strategies);
      default = lib.last (lib.attrNames strategies);
      description = "Zapret strategy to use.";
    };

    excludeHosts = lib.mkOption {
      type = lib.types.listOf (lib.types.strMatching "[A-Za-z0-9]([A-Za-z0-9.-]*[A-Za-z0-9])?");
      default = [ ];
      example = [ "nix-community.cachix.org" ];
      description = "Domains to leave unmodified on TCP ports 80, 443 and 8443.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.zapret = {
      enable = true;
      udpSupport = true;
      inherit (strategy) udpPorts;
      params = [
        "--bind-fix4"
      ]
      ++
        lib.optional (cfg.excludeHosts != [ ])
          "--filter-tcp=80,443,8443 --hostlist=\"${pkgs.writeText "zapret-excluded-hosts" (lib.concatLines cfg.excludeHosts)}\" --new"
      ++ strategy.filters;
    };

    networking.hostFiles = lib.optional cfg.addHosts "${flowsealData}/.service/hosts";

    networking.firewall = lib.mkIf config.services.zapret.configureFirewall {
      extraCommands = lib.concatMapStringsSep "\n" (
        port: "ip46tables -t mangle -I POSTROUTING -p tcp --dport ${port} ${firstPackets} ${queue}"
      ) strategy.extraTcpPorts;

      extraStopCommands = ''
        for port in 80 443 8443; do
          while iptables -w -t mangle -D POSTROUTING -p tcp --dport "$port" ${firstPackets} ${queue} 2>/dev/null; do :; done
        done
        while iptables -w -t mangle -D POSTROUTING -p udp -m multiport --dports ${lib.concatStringsSep "," config.services.zapret.udpPorts} ${queue} 2>/dev/null; do :; done
      '';
    };
  };
}
