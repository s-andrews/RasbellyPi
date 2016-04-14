#!/usr/bin/perl
use warnings;
use strict;
use Date::Calc qw(Delta_Days);
use Time::Local;

package Sound::SoundCollection;


sub new {

  my ($package,$files) = @_;

  my $data = {
	      files => $files,
	     };  

  return bless $data;
  
}


sub set_date_range {

  my ($obj,$start_month,$start_day,$end_month,$end_day) = @_;

  my $current_year = (localtime(time()))[5] + 1900;

  my $duration = Delta_Days($current_year,$start_month,$start_day,$current_year,$end_month,$end_day);

  $obj -> {start_month => $start_month,
	   end_month => $end_month,
	   start_day => $start_day,
	   end_day => $end_day,
	   duration => $duration};
}

sub is_valid {

  # Test to see if the current date is within the range required for this
  # collection

  my ($obj) = @_;

  # Check if there is a range set at all
  unless (exists $obj -> {start_month}) {
    return 1;
  }

  my $current_year = (localtime(time()))[5] + 1900;
  my $lower_time = timelocal(0,0,0,$obj->{start_day},$obj->{start_month},$current_year);
  my $upper_time = timelocal(59,59,23,$obj->{end_day},$obj->{end_month},$current_year);
  my $current_time = localtime();

  if ($current_time >= $lower_time && $current_time <= $upper_time) {
    return(1)
  }
  return(0);
  
  
  
}


sub get_file {

  my ($obj) = @_;


  return $obj -> {files} -> [int rand(scalar @{$obj->{files}})];
  
}

1;
