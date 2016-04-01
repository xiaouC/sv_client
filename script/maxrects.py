'''
Max Rects bin packing for cocos2d spritesheet

@author: suning
@version: 1.0
@requires: Python Image Library
'''


import os
import sys
import glob
import copy
import traceback
from PIL import Image
from PIL import ImageDraw
from PIL import ImageChops


def initFromDict(d):
    'utility method for ctor of an object'
    self = d.pop('self')
    for n, v in d.iteritems():
        setattr(self, n, v)


class pixelRect(object):
    'class for rectangle: x, y, w, h'
    def __init__(self, x=0, y=0, w=0, h=0):
        initFromDict(locals())


class frameObject(object):
    'frameObject contains: frame, rotated, offset, sourceColorRect, sourceSize'
    def __init__(self, name='frame.png', frame=pixelRect(), rotated=False, offset=[0, 0],
                 sourceColorRect=pixelRect(), sourceSize=[0, 0]):
        initFromDict(locals())

    def __str__(self):
        return '''
            <key>%s</key>
            <dict>
                <key>frame</key>
                <string>{{%d, %d}, {%d, %d}}</string>
                <key>offset</key>
                <string>{%d, %d}</string>
                <key>rotated</key>
                <%s/>
                <key>sourceColorRect</key>
                <string>{{%d, %d}, {%d, %d}}</string>
                <key>sourceSize</key>
                <string>{%d, %d}</string>
            </dict>''' % (self.name, self.frame.x, self.frame.y, self.frame.w, self.frame.h,
                          self.offset[0], self.offset[1], 'true' if self.rotated else 'false',
                          self.sourceColorRect.x, self.sourceColorRect.y,
                          self.sourceColorRect.w, self.sourceColorRect.h,
                          self.sourceSize[0], self.sourceSize[1])


class maxRects(object):
    'class of max rects bin packing algorithm - BSSF (Best Short Side Fit)'
    MAX_LEN = sys.maxsize
    outputIndex = 0
    processedFiles = []

    def __init__(self, w, h):
        self.width = w
        self.height = h
        self.freeRects = [pixelRect(0, 0, w, h)]

    def readImageContent(self, image):
        im = Image.open(image, 'r')
        #use transparent white color as transparency
        #or use the bottom right pixel im.getpixel((im.size[0]-1,im.size[1]-1))
        color = (255, 255, 255, 0)
        bg = Image.new(im.mode, im.size, color)
        diff = ImageChops.difference(im, bg)
        bbox = diff.getbbox()
        if bbox:
            x, y, w, h = bbox
            w -= x
            h -= y
            offsetx = -(im.size[0] / 2 - w / 2 - x)
            offsety = (im.size[1] / 2 - h / 2 - y)
            frm = frameObject(name=image, offset=[offsetx, offsety], sourceColorRect=pixelRect(x, y, w, h), sourceSize=list(im.size))
            return frm
        else:
            raise ValueError("Image %s is empty!" % image)

    def readInputObjects(self):
        #read all input objects from Image files in current directory
        frameObjects = []
        files = glob.glob('*.png')
        files = [f for f in files if f not in maxRects.processedFiles]
        for f in files:
            frameObjects.append(self.readImageContent(f))
        return frameObjects

    def insertRect(self, frame):
        #execute best short side fit insertion
        rotated = False
        result = pixelRect()
        bestShortSide = bestLongSide = maxRects.MAX_LEN
        for r in self.freeRects:
            rect = frame.sourceColorRect
            if r.w >= rect.w and r.h >= rect.h:
                gapw = r.w - rect.w
                gaph = r.h - rect.h
                shortSide = min(gapw, gaph)
                longSide = max(gapw, gaph)
                if (bestShortSide > shortSide or
                    (bestShortSide == shortSide and
                     bestLongSide > longSide)):
                        rotated = False
                        bestShortSide = shortSide
                        bestLongSide = longSide
                        result = pixelRect(r.x, r.y, rect.w, rect.h)
            if r.w >= rect.h and r.h >= rect.w:
                gapw = r.w - rect.h
                gaph = r.h - rect.w
                shortSide = min(gapw, gaph)
                longSide = max(gapw, gaph)
                if (bestShortSide > shortSide or
                    (bestShortSide == shortSide and
                     bestLongSide > longSide)):
                        rotated = True
                        bestShortSide = shortSide
                        bestLongSide = longSide
                        result = pixelRect(r.x, r.y, rect.w, rect.h)
        if bestShortSide == maxRects.MAX_LEN:
            frame.name = None
        else:
            frame.frame = result
            frame.rotated = rotated

    def splitFreeRects(self, frmObj):
        to_be_del = []
        count = len(self.freeRects)
        rect = copy.copy(frmObj.frame)
        if frmObj.rotated:
            rect.w, rect.h = rect.h, rect.w
        for i in range(count):
            r = self.freeRects[i]
            if rect.x + rect.w <= r.x or rect.x >= r.x + r.w or rect.y + rect.h <= r.y or rect.y >= r.y + r.h:
                continue
            else:
                newpos = None
                if rect.x + rect.w > r.x and rect.x < r.x + r.w:
                    if rect.y > r.y:
                        newpos = pixelRect(r.x, r.y, r.w, rect.y - r.y)
                        self.freeRects.append(newpos)
                    elif rect.y + rect.h < r.y + r.h:
                        newpos = pixelRect(r.x, rect.y + rect.h, r.w, r.y + r.h - (rect.y + rect.h))
                        self.freeRects.append(newpos)
                if rect.y + rect.h > r.y and rect.y < r.y + r.h:
                    if rect.x > r.x:
                        newpos = pixelRect(r.x, r.y, rect.x - r.x, r.h)
                        self.freeRects.append(newpos)
                    elif rect.x + rect.w < r.x + r.w:
                        newpos = pixelRect(rect.x + rect.w, r.y, r.x + r.w - (rect.x + rect.w), r.h)
                        self.freeRects.append(newpos)
                if newpos is not None:
                    to_be_del.append(i)
        self.freeRects = [r for i, r in enumerate(self.freeRects) if i not in to_be_del]

    def writeOutputObjects(self, frameObjects):
        header = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>frames</key>
        <dict>'''
        tail = '''
        </dict>
        <key>metadata</key>
        <dict>
            <key>format</key>
            <integer>2</integer>
            <key>size</key>
            <string>{%d,%d}</string>
        </dict>
    </dict>
</plist>''' % (self.width, self.height)
        #use dir name as target file name
        #or input raw_input('Please enter output name: ')
        fulldirname = os.path.split(os.getcwd())
        filename = fulldirname[-1] + '_' + str(maxRects.outputIndex)
        maxRects.outputIndex += 1
        fp = open(filename + '.plist', 'w')
        print 'Writing %s ...' % (filename + '.plist')
        fp.write(header)
        for frm in frameObjects:
            fp.write(str(frm))
            maxRects.processedFiles.append(frm.name)
        fp.write(tail)
        fp.close()
        #generate a transparent empty image first then paste sprite on it
        im = Image.new('RGBA', (self.width, self.height), (255, 255, 255, 0))
        transparent_area = (0, 0, self.width, self.height)
        mask = Image.new('L', im.size, color=255)
        draw = ImageDraw.Draw(mask)
        draw.rectangle(transparent_area, fill=0)
        im.putalpha(mask)
        #comment out all debug lines ...
        #drawdebug = ImageDraw.Draw(im)
        #usedcolor = (255,0,0,255)
        #freecolor = (0,255,0,255)
        for frm in frameObjects:
            x, y, w, h = frm.frame.x, frm.frame.y, frm.frame.w, frm.frame.h
            tmp = Image.open(frm.name)
            sx, sy, sw, sh = frm.sourceColorRect.x, frm.sourceColorRect.y, frm.sourceColorRect.w, frm.sourceColorRect.h
            sz = frm.sourceSize[1]
            if frm.rotated:
                tmp = tmp.rotate(270)
                tmp = tmp.crop((sz - sy - sh, sx, sz - sy, sx + sw))
                im.paste(tmp, (x, y, x + h, y + w), tmp)
                #drawdebug.line((x+1,y+1,x+h-1,y+1,x+h-1,y+w-1,x+1,y+w-1,x+1,y+1), fill=usedcolor, width=1)
            else:
                tmp = tmp.crop((sx, sy, sx + sw, sy + sh))
                im.paste(tmp, (x, y, x + w, y + h), tmp)
                #drawdebug.line((x+1,y+1,x+w-1,y+1,x+w-1,y+h-1,x+1,y+h-1,x+1,y+1), fill=usedcolor, width=1)
            del tmp
        #for r in self.freeRects:
        #    drawdebug.line((r.x+1,r.y+1,r.x+r.w-1,r.y+1,r.x+r.w-1,r.y+r.h-1,r.x+1,r.y+r.h-1,r.x+1,r.y+1), fill=freecolor, width=1)
        print 'Writing %s ...' % (filename + '.png')
        im.save(filename + '.png')
        maxRects.processedFiles.append(filename + '.png')


def main():
    try:
        print 'Start packing images: '
        #  set the target texture to 2048
        #  or ask user to input #int(raw_input('Please enter target texture edge length: '))
        size = 2048
        width = height = size
        #  if ask user to input, we need validation here:
        #  assert ((size & (size - 1)) == 0, 'Texture edge length must be power of 2.')
        while True:
            rects = maxRects(width, height)
            frameObjects = rects.readInputObjects()
            if len(frameObjects) == 0:
                break
            frameObjects.sort(key=lambda f: f.sourceColorRect.w * f.sourceColorRect.h, reverse=True)
            for frm in frameObjects:
                rects.insertRect(frm)
                if frm.name is not None:
                    rects.splitFreeRects(frm)
            frameObjects = [f for f in frameObjects if f.name is not None]
            rects.writeOutputObjects(frameObjects)
        print 'Done.'
    except:
        traceback.print_exc(file=sys.stderr)

if __name__ == '__main__':
    main()
