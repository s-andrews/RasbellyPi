#!/usr/bin/perl
use warnings;
use strict;

package Sound::Library;


sub new () {
  return bless {};
}

sub play_sound () {

  warn "Playing a sound\n";
  system ("aplay Sounds/Doorbell/DingDong.wav") == 0 or warn "Failed to play sound";
  
}


1;
