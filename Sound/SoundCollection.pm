#!/usr/bin/perl
use warnings;
use strict;

package Sound::SoundCollection;


sub new {

  my ($package,$files) = @_;

  my $data = {
	      files => $files,
	     };

  return bless $data;
  
}


sub get_file {

  my ($obj) = @_;


  return $obj -> {files} -> [int rand(scalar @{$obj->{files}})];
  
}

1;
