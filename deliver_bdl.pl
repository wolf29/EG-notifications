#!/usr/bin/perl 


my @date = CORE::localtime;
my $d    = $date[3];
my $mon  = $date[4] + 1;
my $year = $date[5] + 1900;

if ($d < 10){$d="0$d";}
if ($mon < 10){$mon="0$mon";}

my $day = "$year-$mon-$d";
my $file= "/openils/var/data/overdue/overdue.$day.xml";

system ("/usr/bin/scp  $file lyrasis\@www.branchdistrictlibrary.org:");


