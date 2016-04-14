#!/usr/bin/perl
use warnings;
use strict;
use Date::Calc;
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

  my $duration = Date::Calc::Delta_Days($current_year,$start_month,$start_day,$current_year,$end_month,$end_day);

  $obj -> {start_month} = $start_month-1;
  $obj -> {end_month} = $end_month-1;
  $obj -> {start_day} = $start_day;
  $obj -> {end_day} = $end_day;
  $obj -> {duration} = $duration;

}

sub duration  {
  my ($obj) = @_;
  if (exists $obj->{duration}) {
    return $obj->{duration};
  }
  return 500;
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
  my $lower_time = Time::Local::timelocal(0,0,0,$obj->{start_day},$obj->{start_month},$current_year);
  my $upper_time = Time::Local::timelocal(59,59,23,$obj->{end_day},$obj->{end_month},$current_year);
  my $current_time = time();

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
