{
  den.aspects.dev = {
    provides.to-hosts.nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          nurl
          go
          delve
        ];
      };
  };
}
