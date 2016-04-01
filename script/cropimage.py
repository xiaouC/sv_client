#!/usr/bin/env python
import re
import sys
from PIL import Image
from os import makedirs
from plistlib import readPlist
from os.path import exists as pathexists, join as pathjoin

def totuple(coordinate):
    tried = coordinate.split('},{')
    if len(tried) == 2:
        x, y = tried
        x = x + '}'; y = '{' + y
    else:
        x, y = coordinate.split(',')

    x = x[1:]; y = y[:-1]
    try:
        x = int(x); y = int(y)
    except ValueError:
        x = totuple(x); y = totuple(y)

    return x, y

def convert_each(image, filename, dd):
    (left, top), (width, height) = totuple(dd['frame'])
    if dd['rotated']:
        width, height = height, width
    sourceSize = totuple(dd['sourceSize'])
    box =  left, top, left+width, top+height #left, top, right, bottom
    region = image.crop(box)
    if dd['rotated']:
        region = region.rotate(90)
    region = region.resize(sourceSize, Image.ANTIALIAS)#NEAREST, BILINEAR, BICUBIC, ANTIALIAS
    region.save(filename, 'png')

def convert(plistpath, dest=None):
    imagepath = re.sub(r'.plist$', '.png', plistpath)
    plist = readPlist(plistpath)
    image = Image.open(imagepath) 
    if dest and not pathexists(dest):
        makedirs(dest)
    for filename, v in plist['frames'].items():
        if dest:
            filename = pathjoin(dest, filename)
        print 'save', filename
        convert_each(image, filename, v)
    print 'done'

if __name__ == '__main__':
    args = sys.argv[1:]
    if len(args) == 1:
        convert(args[0])
    elif len(args) == 2:
        convert(args[0], args[1])
    else:
        pass
