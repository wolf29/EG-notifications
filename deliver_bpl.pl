#!/usr/bin/perl 

use MIME::Lite;

my @date = CORE::localtime;
my $d    = $date[3];
my $mon  = $date[4] + 1;
my $year = $date[5] + 1900;

if ($d < 10){$d="0$d";}
if ($mon < 10){$mon="0$mon";}

my $day = "$year-$mon-$d";
my $file= "/openils/var/data/overdue/bpl_overdue.$day.xml";

my $msg = MIME::Lite->new(
    To      =>'barrytonlibrary@frontier.com',
    From    =>'overdues@michiganevergreen.org',
    Subject =>'Overdues',           
    Type    =>'multipart/mixed'
         );
    $msg->attach(
        Type => "text/xml",
        Path => $file,
        Filename => "bpl_overdue.$day.xml"
         );
    $msg->send('smtp','lyrasistechnology.org',Debug=>0);

