#!/usr/bin/python
# -*- coding: utf-8 -*-
# +------------------------------------------------------------------+
# | Check by Mathias Decker 2013        mathias.decker@mdc-berlin.de |
# | this check gets the current warranty status of a given           |
# | serialnumber                                                     |
# +------------------------------------------------------------------+
# example of output
# Support agreement;#####;HP Next Day HW Support;HP Hardware Maintenance Onsite Support;Jan 1, 2011;Dec 31, 2015;Active

import datetime
import os
import argparse
import sys

parser = argparse.ArgumentParser(description='HP/Dell Warranty Check')
parser.add_argument('-S','--serialnumber',help="serialnumber to check")
parser.add_argument('-M','--manufacturer',help="manufacturer to check")
params = vars(parser.parse_args())

warranties = ""
if params['manufacturer'] == "HP":
	from bs4 import BeautifulSoup
	f = os.popen("curl -s 'http://h20565.www2.hpe.com/hpsc/wc/public/find' --data 'rows%5B0%5D.item.serialNumber="+params['serialnumber']+"&rows%5B0%5D.item.countryCode=US&submitButton=Submit'").read()
	soup = BeautifulSoup(f)

	try:
		rows = soup.find("td", {"id":"generate_table_"+params['serialnumber']}).findAll("tr", {"class":"hpui-normal-row"})
	except:
		rows = []
 
	warranties = u'\n'.join(unicode(u';'.join(unicode(cell.text.strip()) for cell in row.findAll("td"))) for row in rows).replace(";;;\n",";")

if params['manufacturer'] == "Dell":
	from suds.client import Client
	import time
	import uuid
	uuid = uuid.uuid4()

	url = 'http://xserv.dell.com/services/assetservice.asmx?WSDL'
	client = Client(url, location=url)
	res = client.service.GetAssetInformation(uuid,'check_dell_warranty',params['serialnumber'])
	if res == '':
	        print 'error: error retrieving system information from Dell'
	        sys.exit(3)

	warranties = u'\n'.join(unicode("%s;#####;%s;%s;%s;%s;%s" % ( row['ServiceLevelCode'], row['ServiceLevelDescription'], row['Provider'], row['StartDate'].strftime("%b %d, %Y"), row['EndDate'].strftime("%b %d, %Y"), row['EntitlementType'])) for row in res['Asset'][0]['Entitlements']['EntitlementData'])

print warranties



