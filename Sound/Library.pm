#!/usr/bin/perl
use warnings;
use strict;
use Sound::SoundCollection;
use Sound::SoundPlayer;
use File::Glob;

package Sound::Library;


sub new {

  my $debug = 0;
  
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
    my @files = File::Glob::bsd_glob("$directory/*");

    $debug and warn "Found ".scalar @files." files\n";
    
    my @sound_files;

    foreach my $file (@files) {
      if ($file =~ /(\.wav$|\.mp3$)/i) {
	push @sound_files,$file;
      }
      else {
	$debug and warn "$file is not a sound file";
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

	next unless ($_);
	
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

  my @valid_collections;

  if ((localtime())[5]+1900 >=2016) {
    # We have a clock we can trust

    foreach my $collection (@$obj) {
      if ($collection -> is_valid()) {
	push @valid_collections,$collection;
      }
    }
  }
  else {
    # We can't trust the clock - only use the
    # collections which don't have a time limit
    # on them
    foreach my $collection (@$obj) {
      unless ($collection -> is_limited()) {
	push @valid_collections,$collection;
      }
    }
    
  }

  

  unless (@valid_collections) {
    warn "There are no valid sound collections!!  Can't play anything\n";
    return;
  }
  
  # From the valid collections we sort by their
  # duration so we always select the most specific
  # collection which is currently valid.

  @valid_collections = sort {$a -> duration() <=> $b -> duration()} @valid_collections;

  # We now want to select from the set of shortest duration collections
  my $last_index = 0;

  for my $i(1..$#valid_collections) {
    if ($valid_collections[$i]->duration() == $valid_collections[0]->duration()) {
      $last_index = $i;
    }
    else {
      last;
    }
  }
  
  my $collection = @valid_collections[int rand($last_index+1)];

  my $file = $collection->get_file();

  warn "Playing $file\n";

  my $player = new Sound::SoundPlayer();

  $player -> play_sound($file);
  
  
}


1;
