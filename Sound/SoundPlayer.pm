#!/usr/bin/perl
use warnings;
use strict;

package Sound::SoundPlayer;


sub new  {
  return bless {};
}


sub play_sound  {

  my ($obj,$file) = @_;

  my $os = $^O;

  if ($os eq 'linux') {
    _play_sound_linux($file);
  }
  elsif ($os eq 'darwin') {
    _play_sound_osx($file);
  }
  else {
    die "Don't recognise OS $os";
  }
  
}

sub _play_sound_linux {

  my ($file) =  @_;

  if ($file =~ /\.wav$/i) {
    system ("aplay", $file) == 0 or warn "Failed to play '$file'";
  }
  elsif ($file =~ /\.mp3$/i) {
    system ("omxplayer", $file) == 0 or warn "Failed to play '$file'";
  }
  
}

sub _play_sound_osx {
  my ($file) = @_;
  system("afplay",$file) == 0 or warn "Failed to play '$file'";
}


1;

