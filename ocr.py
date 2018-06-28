#!/bin/python
#coding=utf-8
from PIL import Image
import codecs
import sys
import pyocr
import datetime
dd = str(datetime.date.today())
dpath = "/var/www/html/cacti/"+dd+"/"
png = ("68.png", "70.png",  "72.png", "73.png", "93.png", "94.png", "81.png", "82.png", "84.png", "87.png")
#builder = pyocr.builders.TextBuilder()
builder = pyocr.tesseract.DigitBuilder() 
tools = pyocr.get_available_tools()[:]
if len(tools)==0:
    print("no ocr tool found")
    sys.exit(1)
else:
    print("Using '%s' " % (tools[0].get_name()))
for i in png:
    image = Image.open(dpath+i)
    data = tools[0].image_to_string(image, lang='eng', builder=builder)
    with codecs.open(dpath+"data.txt", 'a+',encoding='utf-8') as file_descriptor:
        builder.write_file(file_descriptor, data+'\n')
