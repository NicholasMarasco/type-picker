#!/usr/bin/perl

use strict;
use File::Basename;

# Build usage message
my $cmd = basename($0);
my $usage = "usage: $cmd <name-file>\n";

# Args check
die "$usage\n" if (@ARGV != 1);

# Check data file
my $datafile = $ARGV[0];
#print "datafile: $datafile\n";
die "No such file exists: $datafile\n" if (! -e $datafile);
open(IN, '<', $datafile) or die "Cannot open file for reading: $datafile\n";
open(OUT,'>', "$datafile~") or die "Cannot open file for writing: $datafile~\n";

my @types = ("Bug","Dark","Dragon","Electric","Fairy","Fighting","Fire",
             "Flying","Ghost","Grass","Ground","Ice","Normal","Poison",
             "Psychic","Rock","Steel","Water");
my @spent = (0..$#types);
 
# Check for types already in use
while(<IN>){
    chomp;
    next if /^\s*#/;
    next if /^\s*$/;
    my @line = split/:/;
    $spent[$line[2]] = $line[1] if(defined $line[1]);
}
die "Too many people for unique types.\nToo lazy to fix\n" if ($. > 18);

# Pick types for those without
seek IN,0,0;   
while(<IN>){
    chomp;
    next if /^\s*#/;
    next if /^\s*$/;
    my @line = split/:/;
    #print "@line\n";
    if (!defined $line[1]){
        my $randId = int(rand(@types));
        $randId = int(rand(@types)) until( $spent[$randId] =~ /\d+/ );
        $spent[$randId] = $types[$randId];
        $line[1] = $types[$randId];
        $line[2] = $randId;
    }
    print "$line[0] -> $line[1]:$line[2]\n";
    print OUT "$line[0]:$line[1]:$line[2]\n";
}
# Clean up
close IN;
close OUT;
unlink $datafile;
rename "$datafile~",$datafile;
print "\nDone\n";