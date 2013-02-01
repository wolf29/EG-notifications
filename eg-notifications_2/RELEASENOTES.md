Release Notes
=============
Version 2 

This version of EG-Notifications is based on a python script designed 
by BC-Library Cooperative.  The original was done in python 2.6.x.
This version is being updated to python 3.x so it might work in the 
current Ubuntu OS without hunting down Python 2.7.x.  
This script requires python module reportlab.

To use on Debian Squeeze, you will need backports repository, however 
to run Evergreen 2.2 and higher, you already needed backports.

-- Expected in version 2.0 --
- Generalized code, not hard-coded to any specific library.
- Front-end data, like the branch id and name pulled from 
   EG database for easy deployment.
- Fully customizable notification interval   

#------------------------------------------------------------------#
Version 1
This is a mixture of perl and bash scripts 
The scripts worked pretty well with the 1.6 to 2.0.x Evergreen-ILS
