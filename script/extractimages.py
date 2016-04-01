#!/usr/bin/python
# coding: utf-8

import shutil
from xml.dom import minidom

fla_image_cache = {}

def extractimages(flaroot, dst):
    dom = minidom.parse(os.path.join(flaroot, 'DOMDocument.xml'))
    for each in dom.getElementsByTagName('DOMBitmapItem'):
        src = os.path.join(flaroot, 'LIBRARY', each.getAttribute('name'))

        dstfile = os.path.join(dst, os.path.basename(each.getAttribute('name')))

        if dstfile.lower() in fla_image_cache:
            print u'重名图片 %s , 上次出现于 %s' % (os.path.basename(dstfile), fla_image_cache[dstfile.lower()])
            continue
            #raise Exception

        fla_image_cache[dstfile.lower()] = os.path.basename(flaroot)

        if not os.path.exists(src):
            print u'文件不存在', src
        else:
            shutil.copyfile(src, dstfile)

if __name__ == '__main__':
    import os, sys
    if len(sys.argv)>2:
        inputroot = sys.argv[1]
        outputroot = sys.argv[2]
    else:
        inputroot = '../fla'
        outputroot = './allimages'

    if not os.path.isdir(outputroot):
        print 'create directory', outputroot
        os.mkdir(outputroot)

    for d in os.listdir(inputroot):
        if d.endswith('.svn'):
            continue
        d = os.path.join(inputroot, d)
        if not os.path.isdir(d):
            continue
        print u'处理flash', d
        extractimages(d, outputroot)
