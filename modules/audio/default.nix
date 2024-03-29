# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, ... }:

{
environment.systemPackages = with pkgs; [
	guitarix
	ardour
	jack2
	libjack2
	qjackctl
];

sound.enable = false;
# hardware.pulseaudio.enable = true;
hardware.pulseaudio.enable = false;
# rtkit is optional but recommended
security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  jack.enable = true;
};
}
