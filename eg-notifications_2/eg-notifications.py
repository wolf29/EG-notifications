#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  eg-notifications.py
#  
#  Base document code
#  Copyright   GPLv2 , © 2012 BC Libraries Cooperative
#  Additions           © 2013 Wolf Halton <wolf@sourcefreedom.com>
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

from cStringIO import StringIO
from string import letters, digits
from xml.dom.minidom import *
from xml.sax.saxutils import escape
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch, cm
from reportlab.pdfgen.canvas import Canvas
from reportlab.platypus import Paragraph, SimpleDocTemplate, PageBreak, Spacer, XPreformatted, Image
from reportlab.platypus.tables import LongTable, TableStyle, Table
from email import MIMEText, MIMEBase, MIMEMultipart
from smtplib import SMTP
from base64 import encodestring
import pprint, sys, time

python_version = "3"
version = "2"

def prepDataValue(data_value):
	if data_value == None:
		return u'(No information available)'
	return data_value.data

def prepPriceValue(data_value):
	if data_value == None:
		return u'0.00'
	return data_value.data


pretty_print = pprint.PrettyPrinter(indent=4)

styles = getSampleStyleSheet()

centre_style = ParagraphStyle({})
centre_style.fontName = 'Helvetica'
centre_style.fontSize = 10.5
centre_style.alignment = 1

libname_style = ParagraphStyle({})
libname_style.fontName = 'Helvetica-Bold'
libname_style.fontSize = 12
libname_style.alignment = 1

header_table_style = TableStyle([('VALIGN', (0, 0), (-1, -1), 'MIDDLE')])

normal_style = styles['Normal']
normal_style.fontName = 'Helvetica'
normal_style.fontSize = 10.5

heading_style = styles['Heading1']
heading_style.fontName = 'Helvetica-Bold'
heading_style.alignment = 1

overdue_table_style = TableStyle([	('FONTSIZE', (0, 0), (-1, -1), 10.5),
					('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
					('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
					('VALIGN', (0, 0), (-1, -1), 'TOP'),
					('BOTTOMPADDING', (0, 0), (-1, -1), 7),
					('LEFTPADDING', (0, 0), (-1, -1), 12),
					('RIGHTPADDING', (0, 0), (-1, -1), 12)
				])
				
xml_records = parse(sys.argv[1])
magic_bag = []
overdue_table = []
number_of_notices = 0

date_of_notice = time.strftime('%B %e, %Y', time.strptime(xml_records.getElementsByTagName('file')[0].getAttribute('date'), '%m/%d/%Y'))

for notice in xml_records.getElementsByTagName("notice"):
	if notice.getElementsByTagName('libname')[0].firstChild.data != 'REDACTED Public Library': #matches what's in XML
		continue	# if not our library, we'll just move on to the next one
	overdue_address_block = '\n'.join([
		notice.getElementsByTagName('fullname')[0].firstChild.data,
		notice.getElementsByTagName('street1')[0].firstChild.data,
		notice.getElementsByTagName('city_state_zip')[0].firstChild.data
	])
	
	overdue_callnumbers = [Paragraph(escape(prepDataValue(this.firstChild)), normal_style) for this in notice.getElementsByTagName('callno')]
	
	## Sometimes, titles can be null in the XML, so we run the NodeChild object
	## through this locally defined function to see if its None. If it is, we 
	## return a dummy value, otherwise, return the data in the node.
	overdue_titles = [Paragraph(escape(prepDataValue(this.firstChild)), normal_style) for this in notice.getElementsByTagName('title')]
	
	#overdue_title_reader = [Paragraph(escape(this.firstChild.data), normal_style) for this in notice.getElementsByTagName('title')]
		
	overdue_barcodes = [this.firstChild.data for this in notice.getElementsByTagName('barcode')]
	overdue_prices = [prepPriceValue(this.firstChild) for this in notice.getElementsByTagName('price')]
	overdue_duedates = [this.firstChild.data for this in notice.getElementsByTagName('duedate')]

	overdue_duedates = map(lambda x: time.strftime("%Y-%b-%d", time.strptime(x, "%m/%d/%Y")), overdue_duedates)

	## To this point, we've thrown away notices that are not for this library. However, we still
	## have notices for this library that will be issued for a notice interval they don't use.
	##
	## Here, we check to see whether the notice is for an interval this library uses, and if it's not,
	## we just don't add it to the magic bag for notice generation. This is the ugliest hack (*) in
	## the universe, but by God, it's going to get the job done before Ben hollers at me.
	##
	## (*) <=> because it means we have to process all the report items with the incorrect time
	##			intervals, parse their titles, authors, etc., from XML and generate ReportLab
	##			objects, all to just throw it away below. But, anyway, it should work.

	notice_interval = notice.getAttribute('count')

	if notice_interval in ('21 days', '42 days', '70 days'): ## notice interval we want for this site
		number_of_notices = number_of_notices + 1

		if notice_interval == '21 days':
			overdue_noticetype = Paragraph('First Overdue Notice', heading_style)
			overdue_field_widths = [1.3 * inch, 1.3 * inch, 1.3 * inch, None]
			overdue_field_headings = [['Due Date', 'Call Number', 'Barcode', 'Title']]
			overdue_fields = zip(overdue_duedates, overdue_callnumbers, overdue_barcodes, overdue_titles)
		if notice_interval == '42 days':
			overdue_noticetype = Paragraph('Second Overdue Notice', heading_style)
			overdue_field_widths = [1.3 * inch, 1.3 * inch, 1.3 * inch, None]
			overdue_field_headings = [['Due Date', 'Call Number', 'Barcode', 'Title']]
			overdue_fields = zip(overdue_duedates, overdue_callnumbers, overdue_barcodes, overdue_titles)
		if notice_interval == '70 days':
			overdue_noticetype = Paragraph('Final Overdue Notice', heading_style)
			overdue_field_widths = [1.3 * inch, 1.3 * inch, 1.3 * inch, None, inch]
			overdue_field_headings = [['Due Date', 'Call Number', 'Barcode', 'Title', 'Price']]
			overdue_fields = zip(overdue_duedates, overdue_callnumbers, overdue_barcodes, overdue_titles, overdue_prices)

		uh_ohes_string = 'Library records show the following item(s) overdue. If you have returned the items, please excuse this notice. Otherwise, please return them as soon as possible to avoid increasing fines. Thank you.'
	
		magic_bag.append( {	'patron_address': overdue_address_block,
		'notice_type': overdue_noticetype,
		'uh_ohes_string': uh_ohes_string,
		'suffix_string': '',
		'column_widths': overdue_field_widths,
		'overdue_items': overdue_field_headings + overdue_fields })


### So now, we've finished processing the relevant items into the 
### magic bag, throwing away what we don't want, and we'll start generating reports.

story = []

libname_string = 'REDACTED Public Library'
pr_address_string = '''1123 REDACTED St.
REDACTEDTOWN BC V0V 0V0
Phone: 123-456-7890  Fax: 123-456-7890
E-mail: REDACTED@REDACTED.com
Website: http://REDACTED.com
'''
header_table = Table([
	[XPreformatted(libname_string, libname_style)], 
	[XPreformatted(pr_address_string, centre_style)]])


for report in magic_bag:
	story.append( Table([[Image('/opt/eg-sundrywidgets/LIBRARY-logo-smallest.jpg'), header_table]], colWidths=[1.6 * inch, 3 * inch], style=header_table_style) )
	#story.append(XPreformatted(pr_address_string, centre_style))
	story.append(Spacer(1.0, .2 * inch))
	story.append(XPreformatted(report['patron_address'], normal_style))
	story.append(Spacer(1.0, .8 * cm))
	story.append(Paragraph(date_of_notice, normal_style))
	story.append(Spacer(1.0, .5 * cm))
	story.append(report['notice_type'])
	story.append(Spacer(1.0, .5 * cm))
	story.append(Paragraph(report['uh_ohes_string'], normal_style))
	story.append(Spacer(1.0, .5 * cm))
	story.append(LongTable(report['overdue_items'], colWidths=report['column_widths'], style=overdue_table_style, repeatRows=1 ))
	story.append(Spacer(1.0, .5 * cm))
	story.append(Paragraph(report['suffix_string'], normal_style))
	story.append(PageBreak())

pdf_pseudofile = StringIO()
doc = SimpleDocTemplate(pdf_pseudofile, pagesize=letter, topMargin=2*cm, leftMargin=1.8*cm, rightMargin=1.8*cm, bottomMargin=1.5*cm)
doc.build(story)

main_message = MIMEMultipart.MIMEMultipart()
main_message['From'] = 'REDACTED@REDACTED.CA'
main_message['To'] = 'REDACTED@REDACTED.com'
main_message['Subject']  = 'SHORTNAME '.join(['Overdue Notices -', date_of_notice, ' ', str(number_of_notices), ' notices today'])

text_part = MIMEText.MIMEText('Overdue notices for ' + date_of_notice + ' are attached.\n')
text_part.add_header('Content-Disposition', 'inline')
main_message.attach(text_part)

att_filename = ''.join(['overdue-bvale-', filter(lambda char: char in letters + digits, date_of_notice).lower(), '.pdf'])
attachment_part = MIMEBase.MIMEBase('application', 'pdf')
attachment_part.set_payload(encodestring(pdf_pseudofile.getvalue()))
attachment_part.add_header('Content-Disposition', 'attachment', filename=att_filename)
attachment_part.add_header('Content-Transfer-Encoding', 'base64')
main_message.attach(attachment_part)

mail_service = SMTP('REDACTED-SMTP-SERVER')

# Are we running this in production (first command commented), or testing (second command commented)?

#if number_of_notices > 0:
#mail_service.sendmail('REDACTED@REDACTED.ca', ['REDACTED@REDACTED.ca'], main_message.as_string())
mail_service.sendmail('paper-overdue@REDACTED.ca', ['paper-overdue@REDACTED.ca', 'THELIBRARY@REDACTED.ca'], main_message.as_string())

mail_service.quit()
