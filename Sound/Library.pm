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

    my $collection = new Sound::SoundCollection(\@sound_files);
    
    if (@sound_files) {
      push @$data, $collection;
    }

    # Now see if there is a time_limit.txt file which restricts
    # when these sounds would be relevant
    if (-e "$directory/time_limit.txt") {

      my $start_day;
      my $start_month;
      my $end_day;
      my $end_month;

      open (LIMIT,"$directory/time_limit.txt") or die "Can't read $directory/time_limit.txt";
      while (<LIMIT>) {
	next if (/^#/);

	s/[\r\n]//g;
	s/\s+$//;
	
	my ($key,$value) = split(/\s*=\s*/);

	unless ($value =~ /^\d+$/) {
	  warn "Value was not an integer in $_ in $directory/time_limit.txt";
	  next;
	}

	if ($key eq 'start_day') {
	  $start_day = $value;
	}
	elsif ($key eq 'start_month') {
	  $start_month = $value;
	}
	elsif ($key eq 'end_day') {
	  $end_day = $value;
	}
	elsif ($key eq 'end_month') {
	  $end_month = $value;
	}
      }

      close LIMIT;

      unless ($start_day and $start_month and $end_day and $end_month) {
	warn "Not enough values to specific time limit in  $directory/time_limit.txt";
      }
      else {
	$collection -> set_date_range($start_month,$start_day,$end_month,$end_day);
      }      
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
