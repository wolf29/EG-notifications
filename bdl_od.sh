#!/bin/bash
# ---------------------------------------------------------------
# This file runs the overdue generation script.
# If today is Monday, it runs the script for Sat/Sun/Mon, 
# otherwise it runs once per day.
# ---------------------------------------------------------------




SSH_CLIENT=$1
RECIPIENT=$2;
DATE=$(date +%Y-%m-%d);
DAY=$(date +%u);
BSCONFIG="/openils/conf/opensrf_core.xml"
ODDIR="/openils/var/data/overdue";

export EG_OVERDUE_EMAIL_TEMPLATE="overdue_notice_email";
export EG_OVERDUE_SMTP_HOST="";
export EG_OVERDUE_EMAIL_SENDER="evergreen@localhost";

[ $(whoami) != "opensrf" ] && echo "Must be run as opensrf" && exit 1;
source ~/.bashrc;
ARGS="0"

#[ $DAY == 6 -o $DAY == 7 ] && exit 0; # don't run on saturday or sunday
#if [ $DAY == 1 ]; then ARGS="2 1 0"; fi; # If today is monday, run for sat/sun/mon

./bdl_od.pl $BSCONFIG $ARGS > "$ODDIR/overdue.$DATE.xml"

