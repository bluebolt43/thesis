#!/usr/bin/python
import sys
import re

content = open("out", "rb")
output = open("out.txt", "wr+")
#print "Name of the file: ", content.name

count=0
totalsecond=0
for line in content:
	#print "Read Line: %s" % (line)
	buf = line.split()
	if len(buf)>1 :
		if count != 0:
			#print "avg %f %f" % (totalsecond, (totalsecond / (count)))
			output.write("%f\n" % (totalsecond / (count)))
			count=0
			totalsecond=0
		#print "%s" % line
		if buf[0] == "valgrind":
			output.write("%s\n" % buf[0])
		else:
			output.write("%s" % line)
	else:
		readsecond = int(line.split('m')[0])*60
		readsecond += float(line.split('m')[1][:-2])
		#print "%f" % readsecond
		#output.write("%f\n" % readsecond)
		count += 1
		totalsecond += readsecond

if count != 0:
	output.write("%f\n" % (totalsecond / (count)))


content.close()
output.close()

