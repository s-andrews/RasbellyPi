#!/usr/bin/perl
use warnings;
use strict;
use Sound::SoundCollection;

package Sound::Library;


sub new {

  my $debug = 1;
  
  my ($package,$base_dir) = @_;

  $debug and warn "Getting sounds from $base_dir\n";
  
  # List the directories under the base - each of these will be a sound collection
  my @subdirs = <$base_dir/*>;

  $debug and warn "Found ".scalar @subdirs." subdirectories\n";
  
  my $data = [];
  bless $data;

  foreach my $directory (@subdirs) {

    $debug and warn "Looking at directory $directory\n";
    
    next unless (-d $directory);
    my @files = <$directory/*>;

    $debug and warn "Found ".scalar @files." files\n";
    
    my @sound_files;

    foreach my $file (@files) {
      if ($file =~ /(\.wav$|\.mp3$)/) {
	push @sound_files,$file;
      }
    }

    $debug and warn "Found ".scalar @sound_files." sound files\n";

    
    if (@sound_files) {
      push @$data, new Sound::SoundCollection(\@sound_files);
    }
  }
  
  return $data;
}

sub play_sound {

  my ($obj) = @_;

  # TODO: Work out which collections are valid and pick the best one

  my $collection = $obj->[int rand (scalar @$obj)];

  my $file = $collection->get_file();

  if ($file =~ /\.wav$/i) {
    system ("aplay", $file) == 0 or warn "Failed to play '$file'";
  }
  elsif ($file =~ /\.mp3$/i) {
    system ("omxplayer", $file) == 0 or warn "Failed to play '$file'";
  }
  
}


1;
