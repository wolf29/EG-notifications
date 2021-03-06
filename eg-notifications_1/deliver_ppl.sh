#!/bin/bash -x 
#  deliver_ppl.sh 
#  
#  Copyright 2013 Wolf Halton  <wolf@sourcefreedom.com>
#  Copyright 2008 The Evergreen-ILS Project 
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

ddate="`date +'%F'`"
echo "${ddate} is today's date"

file="/openils/var/data/overdue/ppl/ppl_overdue_${ddate}_print.pdf"
echo "$file is the file being sent"

/usr/bin/mutt -s 'Overdue Notices' -a $file -- churchla@portsmouthva.gov  < /home/opensrf/EG-notifications/file_delivery.txt
