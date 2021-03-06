#!/bin/bash 
#
#  install.sh
#  
#  Copyright 2013 Wolf Halton  <wolf@sourcefreedom.com>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  

## This is not complete because it is hard to say how the structure 
##      will be done in /openils/var/data/overdue/[your-first-system]/
##                                                 
##-- Files that go into /openils/bin/
##      deliver_ppl.pl  ## Only use this one if you are pushing the 
##                      ## overdues print files to a server for 
##                      ## retrieval by library staff
##      deliver_ppl.sh  ## Only use this one if you are emailing the  
##                      ## overdues print files to a server  
##      oils_header.pl 
##      ppl_od.sh 
##      ppl_od.pl
##      xml_transform.sh
##      [other-system]_od.sh and [other-system]_od.pl

##-- Files that stay in this folder
##      file_delivery.txt         
##      install.sh         
##      overdue_notice_email  overdues-print.css        

##-- Files that go into /openils/var/data/overdue/
##       overdues-common.css
##       overdues.xsl  
##       overdues-print.css

##-- Files that go into /openils/var/data/overdue/[your-first-system]/
##-- Seems to work best with these in the folders
##       overdues-common.css
##       overdues.xsl  
##       overdues-print.css

mkdir -p /openils/var/data/overdue/ppl
mkdir -p /openils/var/data/overdue/ccpl
mkdir -p /openils/var/data/overdue/mcat
mkdir -p /openils/var/data/overdue/mcat-gc

cp -b ./deliver_ppl.pl /openils/bin/deliver_ppl.pl
cp -b ./oils_header.pl /openils/bin/oils_header.pl
cp -b ./ppl_od.sh /openils/bin/ppl_od.sh
cp -b ./deliver_ppl.sh /openils/bin/deliver_ppl.sh
cp -b ./ppl_od.pl /openils/bin/ppl_od.pl
cp -b ./ppl_xml_transform.sh /openils/bin/ppl_xml_transform.sh
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
cp -b ./mcat-gc_od.sh /openils/bin/mcat-gc_od.sh
cp -b ./deliver_mcat-gc.sh /openils/bin/deliver_mcat-gc.sh
cp -b ./mcat-gc_od.pl /openils/bin/mcat-gc_od.pl
cp -b ./mcat-gc_xml_transform.sh /openils/bin/mcat-gc_xml_transform.sh

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
cp -b ./*.xsl /openils/var/data/overdue/mcat-gc/
cp -b ./*.css /openils/var/data/overdue/mcat-gc/
