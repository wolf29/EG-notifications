EG-notifications
================
Current version - 1.0 
This is deployed to production at least on one library system.


A work-around for an Evergreen action-triggers issue.  
The action-triggers for Overdue notifications are great ideas and
library systems love the granular nature of their theoretical behaviour.
The problem is that they don't always work as advertized.
I got these scripts from the Michigan Evergreen project which got them
from an early version of Evergreen-ILS. I have adjusted them to make 
deployment easier.  

The scripts produce xml files that create both email-to-patron
notifications and email-to-library-system printable mailable 
notifications.  

Some detail on where this work-around puts things:

This is not complete because it is hard to say how the structure
  will be done in /openils/var/data/overdue/[your-first-system]/

-- Files that go into /openils/bin/
 deliver_ppl.pl ## Only use this one if you are pushing the
  overdues print files to a server for
  retrieval by library staff
 deliver_ppl.sh ## Only use this one if you are secure-copying the
  overdues print files to a server
 oils_header.pl
 ppl_od.sh
 ppl_od.pl
 xml_transform.sh
 [other-system]_od.sh and [other-system]_od.pl

-- Files that stay in this folder
 file_delivery.txt
 install.sh
 overdue_notice_email overdues-print.css

-- Files that go into /openils/var/data/overdue/
 overdues-common.css
 overdues.xsl
 overdues-print.css

-- Files that go into /openils/var/data/overdue/[your-first-system]/
-- Seems to work best with these in the folders
 overdues-common.css
 overdues.xsl
 overdues-print.css

 To Do: 
 1) The install.sh algorithm just puts files in place without checking
   whether they are already there, so it may clobber customizations
   The copy commands in the install.sh script make a backup of your old
   version of the files. 
 2) better install program algorithm
   a)  An automated system that populates <$lib-short-name> into the names of the 
   system-specific scripts (simplest) or
   b)  An automated system that puts the <$lib-short-name> and details into 
   generic versions of the scripts on the fly, so there doesn't have to be 
   library-specific scripts at all. (more elegant)
   
   The problem with spending a lot of time on these scripts is that as soon
   as Evergreen-ILS action-triggers work, we stop development on the
   work-around

