{
  den.aspects.ember.nixos =
    { pkgs, ... }:
    {
      boot.extraModprobeConfig = ''
        options snd-hda-intel patch=hda-jack-retask.fw,hda-jack-retask.fw,hda-jack-retask.fw,hda-jack-retask.fw
      '';

      hardware.firmware = [
        # force thinkpad to always use internal mic
        (pkgs.writeTextDir "lib/firmware/hda-jack-retask.fw" ''
          [codec]
          0x10ec0293 0x17aa5050 0

          [pincfg]
          0x12 0x90a60130
          0x13 0x40000000
          0x14 0x90170110
          0x15 0x03211040
          0x16 0x21211010
          0x18 0x411111f0
          0x19 0x21a11010
          0x1a 0x90a60160
          0x1b 0x411111f0
          0x1d 0x40738105
          0x1e 0x411111f0
        '')
      ];
    };
}
