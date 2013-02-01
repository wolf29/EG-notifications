#!/bin/bash -x

#  ppl_xml_transform.sh  
#  
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
#====================================
# This script runs xsltproc to get an xml file that is specifically
# the print version of the xml data.
# and runs prince to make that xml file into a PDF

cd /openils/var/data/overdue/ppl/


myfile="`find -maxdepth 1 -name "*.xml" -mmin -120`"

echo "$myfile is the file we are taking"

slim="`echo $myfile | cut -d '.' -f 2 | cut -d '/' -f 2`"

echo "$slim is the stub"

xsltproc /openils/var/data/overdue/ppl-overdues.xsl $myfile > "${slim}_print.xml"

prince_pack="${slim}_print.xml"

echo "${prince_pack} is the package for Prince"

prince "${prince_pack}"



