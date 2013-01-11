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

cp ./deliver_ppl.pl  /openils/bin/deliver_ppl.pl
cp ./oils_header.pl /openils/bin/oils_header.pl
cp ./ppl_od.sh /openils/bin/ppl_od.sh
cp ./deliver_ppl.sh /openils/bin/deliver_ppl.sh
cp./ppl_od.pl /openils/bin/ppl_od.pl
cp ./xml_transform.sh /openils/bin/xml_transform.sh

chmod +x /openils/bin/*.sh
chmod +x /openils/bin/*.pl

cp ./*.xsl /openils/var/data/overdue/
cp ./*.css /openils/var/data/overdue/*/
