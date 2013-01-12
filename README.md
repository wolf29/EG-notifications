EG-notifications
================
Current version - 1.0 
This is deployed to production at least on one library system.


A work-around for an Evergreen action-triggers issue.  
The action-triggers for Overdue notifications are great ideas and
library systems love the granular nature of their theoretical behaviour.
The problem is that they don't always work as advertized.
I got these scripts from the Michigan Evergreen project and have 
adjusted them to make deployment easier.  

The scripts produce xml files that create both email-to-patron
notifications and email-to-library-system printable mailable 
notifications.  

## Some detail on where this work-around puts things:

## This is not complete because it is hard to say how the structure
## will be done in /openils/var/data/overdue/[your-first-system]/
##
##-- Files that go into /openils/bin/
## deliver_ppl.pl ## Only use this one if you are pushing the
##  overdues print files to a server for
##  retrieval by library staff
## deliver_ppl.sh ## Only use this one if you are secure-copying the
##  overdues print files to a server
## oils_header.pl
## ppl_od.sh
## ppl_od.pl
## xml_transform.sh
## [other-system]_od.sh and [other-system]_od.pl

##-- Files that stay in this folder
## file_delivery.txt
## install.sh
## overdue_notice_email overdues-print.css

##-- Files that go into /openils/var/data/overdue/
## overdues-common.css
## overdues.xsl
## overdues-print.css

##-- Files that go into /openils/var/data/overdue/[your-first-system]/
##-- Seems to work best with these in the folders
## overdues-common.css
## overdues.xsl
## overdues-print.css

# To Do: The install.sh algorithm just puts files in place without checking
#   whether they are already there, so it may clobber customizations
#   The copy commands in the install.sh script make a backup of your old
#   version of the files.
#   We need a checking mechanism to make sure that doesn't happen.
#   The problem with spending a lot of time on these scripts is that as soon
#   as Evergreen-ILS action-triggers work, we stop development on the
#   work-around

mkdir -p /openils/var/data/overdue/ppl
mkdir -p /openils/var/data/overdue/ccpl
mkdir -p /openils/var/data/overdue/mcat

cp -b ./deliver_ppl.pl /openils/bin/deliver_ppl.pl
cp -b ./oils_header.pl /openils/bin/oils_header.pl
cp -b ./ppl_od.sh /openils/bin/ppl_od.sh
cp -b ./deliver_ppl.sh /openils/bin/deliver_ppl.sh
cp -b ./ppl_od.pl /openils/bin/ppl_od.pl
cp -b ./ppl_xml_transform.sh /openils/bin/xml_transform.sh
cp -b ./deliver_ccpl.pl /openils/bin/deliver_ccpl.pl
cp -b ./ccpl_od.sh /openils/bin/ccpl_od.sh
cp -b ./deliver_ccpl.sh /openils/bin/deliver_ccpl.sh
cp -b ./ccpl_od.pl /openils/bin/ccpl_od.pl
cp -b ./ccpl_xml_transform.sh /openils/bin/ccpl_xml_transform.sh
cp -b ./deliver_mcat.pl /openils/bin/deliver_mcat.pl
cp -b ./mcat_od.sh /openils/bin/mcat_od.sh
cp -b ./deliver_mcat.sh /openils/bin/deliver_mcat.sh
cp -b ./mcat_od.pl /openils/bin/mcat_od.pl
cp -b ./mcat_xml_transform.sh /openils/bin/mcat_xml_transform.sh


chmod +x /openils/bin/*.sh
chmod +x /openils/bin/*.pl

cp -b ./*.xsl /openils/var/data/overdue/
cp -b ./*.css /openils/var/data/overdue/
cp -b ./*.xsl /openils/var/data/overdue/ppl/
cp -b ./*.css /openils/var/data/overdue/ppl/
cp -b ./*.xsl /openils/var/data/overdue/ccpl/
cp -b ./*.css /openils/var/data/overdue/ccpl/
cp -b ./*.xsl /openils/var/data/overdue/mcat/
cp -b ./*.css /openils/var/data/overdue/mcat/

