#!/bin/bash
#====================================
# This script runs xsltproc to get an xml file that is specifically
# the print version of the xml data.
# and runs prince to make that xml file into a PDF

cd /openils/var/data/overdue/ppl


myfile=find -maxdepth 1 -name "*.xml" -mmin -20

echo "$myfile is the file we are taking"

slim="`echo $myfile | cut -d '.' -f 2 | cut -d '/' -f 2`"

echo "$slim is the stub"

xsltproc ../overdues.xsl $myfile > "${slim}_print.xml"

prince_pack="${slim}_print.xml"

echo ${prince_pack}

prince "${prince_pack}"



