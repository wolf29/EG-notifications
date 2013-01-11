#!/usr/bin/perl 


my @date = CORE::localtime;
my $d    = $date[3];
my $mon  = $date[4] + 1;
my $year = $date[5] + 1900;

if ($d < 10){$d="0$d";}
if ($mon < 10){$mon="0$mon";}

my $day = "$year-$mon-$d";
my $file= "/openils/var/data/overdue/ppl/ppl_overdue_$day_print.xml";

## system ("/usr/bin/scp  $file grpl\@www.branchdistrictlibrary.org:");
## system ("/usr/bin/scp  $file support\@lyrasistechnology.org:/home/support/lva-overdues/ppl");
system ("/usr/bin/mutt -s "Overdue Notices" -a $file -- wolf.halton@gmail.com < /home/opensrf/overdue/file_delivery.txt")

