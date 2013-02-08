#!/bin/bash
# ---------------------------------------------------------------
# This file runs the overdue generation script.
# If today is Monday, it runs the script for Sat/Sun/Mon, 
# otherwise it runs once per day.
# ---------------------------------------------------------------
# Copyright 2008 The Evergreen-ILS Project 



SSH_CLIENT=$1
RECIPIENT=$2;
DATE=$(date +%Y-%m-%d);
DAY=$(date +%u);
BSCONFIG="/openils/conf/opensrf_core.xml"
ODDIR="/openils/var/data/overdue/mcat-gc";

export EG_OVERDUE_EMAIL_TEMPLATE="overdue_notice_email";
export EG_OVERDUE_SMTP_HOST="";
export EG_OVERDUE_EMAIL_SENDER="mountaincatemail@gmail.com";

[ $(whoami) != "opensrf" ] && echo "Must be run as opensrf" && exit 1;
source ~/.bashrc;
ARGS="0"

#[ $DAY == 6 -o $DAY == 7 ] && exit 0; # don't run on saturday or sunday
[ $DAY == 7 ] && exit 0; # Don't run on Sunday
#if [ $DAY == 1 ]; then ARGS="2 1 0"; fi; # If today is monday, run for sat/sun/mon
if [ $DAY == 1 ]; then ARGS="1 0"; fi; # If today is monday, run for sun/mon


/openils/bin/mcat_od.pl $BSCONFIG $ARGS > "$ODDIR/mcat_overdue_$DATE.xml"

