{
  den.aspects.interloper.nixos =
    { inputs', pkgs, ... }:
    {
      environment.systemPackages = [
        inputs'.disko.packages.disko
      ]
      ++ (with pkgs; [
        git
        helix
        nurl
        nixd
        wget
        curl
        smartmontools
        unzip
        zip
        nixfmt
      ]);
    };
}
