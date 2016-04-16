#!/usr/bin/env python
#-*- coding=utf-8 -*-

'''
主要公式：
a = cos α * Sx
b = sin α * Sy
c = -sin α * Sx
d = cos α * Sy

Sx, Sy 为缩放比例

x'= ax + by + tx
y'= cx + dy + ty
'''
import os
import re
import sys
import math
import traceback
from copy import copy
from PIL import Image
from xml.dom import minidom
from json import dump as jsondump
from collections import defaultdict
from os.path import join as pathjoin, split as pathsplit
import plistlib

# global state
current_filename = ''
inputroot = ''
outputroot = ''

# types
MOVIECLIP = 1
BITMAP = 2
TTFTEXT = 4
FRAME = 7
RECT = 8
BMTEXT = 9
PARTICLE = 11

elemTypes = {
    'DOMBitmapInstance': BITMAP,
    'DOMShape': RECT,
    'DOMSymbolInstance': MOVIECLIP,
    'DOMStaticText': TTFTEXT,
    'DOMDynamicText': TTFTEXT,
}

# ALIGNMENT
ALIGNMENT_LEFT = 0
ALIGNMENT_CENTER = 1
ALIGNMENT_RIGHT = 2

def filename_clean(s):
    if u'补间 ' in s or u'元件 ' in s:
        return current_filename+'/'+s.replace(u'补间 ', 'bujian_').replace(u'元件 ', 'symbol_').replace(' ', '_')
    return s

def filename_unclean(s):
    if 'symbol_' in s or 'bujian_' in s:
        s = s.replace('bujian', u'补间 ').replace('symbol', u'元件 ')
        return s[s.find('/'):]
    return s

ERROR_CODE = 2304
LIBRARY = 'LIBRARY'

def from_angle(a):
    return a*math.pi/180

def to_angle(a):
    return a*180/math.pi

def smart_str(s):
    if isinstance(s, unicode):
        return s.encode('utf-8')
    return s

class qdict(dict):
    def getAttribute(self, key):
        return self.get(key, '')
#====
def gettransfromvalue(m):
    return m.a*m.x + m.b*m.y + m.tx, m.c*m.x + m.d*m.y + m.ty

def getscalevalue(m, angle):  
    cos_a = math.cos(from_angle(angle))
    if cos_a == 0:
        return m.a, m.d
    return m.a/cos_a, m.d/cos_a

def getangle(m):
    if m.d == 0:
        if m.b > 0:
            return 90;
        else:
            return 270;
    return math.atan(-m.c/m.d) * 180 / math.pi;

def getimagesize(pathname, filename):        
    filename = os.path.join(
            os.path.dirname(filename).replace(' ', '_'),
            os.path.basename(filename)
            )
    filename = smart_str(filename)
    #if filename.startswith('PNG') or filename.startswith('png'):
    #    filename = filename.replace('/', '\\')
    if filename.endswith('.png') or filename.endswith('.jpg'):
    	try:
        	return Image.open(pathjoin(pathname, LIBRARY, filename)).size
        except IOError:            
            try : 
                name = filename[filename.rfind("\\")+1:]
                f = pathjoin(outputroot, '%s.plist'%current_filename)
                d = plistlib.readPlist(f)
                for k, v in d['frames'].items():
                    if name != k:
                        continue                
                    r = v['textureRect']
                    origin, size = r[2:-2].split('},{')
                    w, h = map(int, size.split(','))
                    print u'图片的导入方式错误：', pathname, filename                        
                    return (w,h)
            except:
                pass
            print u'没找到图片：', pathname, filename
            return (0,0)
    else:
        dom = minidom.parse(pathjoin(pathname, LIBRARY, '%s.xml'%filename_unclean(filename)))
        element = filter(lambda s:s.nodeType != 3, dom.getElementsByTagName('elements')[0].childNodes)[0]
        filename1 = element.getAttribute('libraryItemName')
        if filename1:
            assert filename1!=filename
            return getimagesize(pathname, filename1)

def getposition(tx, ty, sx, sy, w, h, rotation):
    #return tx+w*sx/2.0, -(ty+h*sy/2.0)
    #return round(tx+w*sx/2.0), round(-(ty+h*sy/2.0))

    if rotation!=0 and False:
        rotation = math.radians(rotation)
        tx, ty = apply(invert(rotate(rotation)), (tx, ty))

    ty = -ty
    w *= sx
    h *= sy
    return tx+w/2.0, ty-h/2.0

def parsecolor(s):
    assert s[0]=='#'
    s = s[1:]
    return int(s[0:2], 16), int(s[2:4], 16), int(s[4:6], 16)
#====

def isflafile(filename):
    '''
    >>> iszipfile('flash/jiuyinbaiguzhuaimage/jiuyinbaiguzhuaimage.fla')
    True
    '''
    if os.system('unzip -O UTF-8 -tq %s'%filename) == ERROR_CODE:
        return False
    return True

def mktempdir(tempdir):
    try:
        os.mkdir(tempdir)
    except:
        return False
    return True

def rmtempdir(tempdir):
    try:
        os.removedirs(tempdir)
    except:
        return False
    return True

def unzipto(filename, tempdir):
    if os.system('unzip -O UTF-8 %s -d %s'%(filename, tempdir)) == ERROR_CODE:
        return False
    return True

#====

def getfirstordefault(sequence, default):
    if not sequence:
        return default
    else:
        return sequence[0]

def getvalueordefault(value, default, func=lambda s:s):
    if value == '':
        return default
    else:
        return func(value)

def isElement(e):
    return e.nodeType!=3

def firstElement(e, name, fn=None):
    l = e.getElementsByTagName(name)
    if l:
        if fn:
            l = filter(fn, l)
        if l:
            return l[0]

def getAttribute(e, name, convert=None, defaultValue=None):
    r = e.getAttribute(name)
    if r:
        if convert:
            return convert(r)
        else:
            return r
    else:
        if defaultValue:
            return defaultValue
        elif convert:
            return convert()

def format_tuple(t):
    return '{%s,%s}'%t

def set_alpha(elem, e):
    try:
        str_alpha = e.getElementsByTagName('Color')[0].getAttribute('alphaMultiplier')        
    except IndexError:
        return;
    if not str_alpha:
        try:
            str_alpha = e.getElementsByTagName('Color')[0].getAttribute('tintMultiplier')        
        except IndexError:        
            return
        if not str_alpha:
            return
    alpha = float(str_alpha)
    if alpha >= 1:
        alpha = alpha / 100
    elem.alpha = int(round(alpha * 255))

def set_color(elem, e):
    try:
        color = e.getElementsByTagName('Color')[0].getAttribute('tintColor')
    except IndexError:
        return
    if not color:
        return
    print 'set color', color
    elem.color = color

def combineBoxes(boxes):
    minX = minY = maxX = maxY = 0
    for ((x,y), (w,h)) in boxes:
        minX = min(minX, x)
        minY = min(minY, y)
        maxX = max(maxX, x+w)
        maxY = max(maxY, y+h)
    return ((minX, minY), (maxX-minX, maxY-minY))

class DictObject(dict):
    def __getattr__(self, k):
        return self[k]
    def __setattr__(self, k, v):
        self[k] = v
    def __delattr__(self, k):
        del self[k]

element_fields = \
  [ ('libName',         None)
  , ('instanceName',    None)
  , ('type',            None)
  , ('position',        (0,0))
  , ('transfromValue',  (0,0))
  , ('scaleValue',      (1,1))
  , ('boundingBox',     ((0,0), (0,0)))
  , ('rotation',        0)
  , ('alpha',           255)
  , ('color',           '#000000')
  , ('text',            '')
  , ('fontSize',        12)
  , ('matrix',          None)
  , ('alignment',       0)
  ]

class Element(DictObject):
    def __init__(self):
        self.scaleValue = (1,1)
        self.size = (0,0)
    def to_plist(self):
        r = copy(self)
        #try:
        #    del r.matrix
        #except KeyError:
        #    pass
        for name, default in element_fields:
            if name=='boundingBox':
                origin, size = r.boundingBox()
                r.boundingBox = format_tuple( (format_tuple(origin), format_tuple(size)) )
                del r.minPos
                del r.size
            elif name not in r:
                continue
            elif r[name] in (None, default):
                del r[name]
            else:
                if name in ('position', 'scaleValue', 'transfromValue'):
                    r[name] = format_tuple(r[name])
        return r

    def boundingBox(self):
        return (self.minPos, self.size)

class Keyframe(DictObject):
    def __init__(self):
        self.startFrame = 0
        self.duration = 1
        self.isMotion = False
        self.elements = []
        self.script = ""

    def to_plist(self):
        r = copy(self)
        r.elementNum = len(r.elements)
        r.elementDict = {}
        for i, e in enumerate(self.elements):
            r.elementDict[str(i)] = e.to_plist()
        del r.elements
        return r

class Layer(DictObject):
    def __init__(self):
        self.keyframes = []
    def to_plist(self):
        r = copy(self)
        if self.keyframes:
            r.frameCount = self.keyframes[-1].startFrame + self.keyframes[-1].duration
        else:
            r.frameCount = 0
        r.keyFrameCount = len(r.keyframes)
        r.keyFrameDict = {}
        for i, kf in enumerate(r.keyframes):
            r.keyFrameDict[str(i)] = kf.to_plist()
        del r.keyframes
        return r

class Symbol(DictObject):
    def __init__(self):
        self.layers = []
        self.anis = []
        self._frameRate = 24
    def to_plist(self):
        r = copy(self)
        #r.anchorPoint = format_tuple(r.anchorPoint)

        origin, size = r.boundingBox
        r.boundingBox = format_tuple( (format_tuple(origin), format_tuple(size)) )

        #r.contentSize = format_tuple(r.size)
        #del r.size
        r.frameCount = max(kf.startFrame+kf.duration for l in r.layers for kf in l.keyframes)
        r.layerCount = len(r.layers)
        r.layerDict = {}
        for i, l in enumerate(r.layers):
            r.layerDict[str(i)] = l.to_plist()
        del r.layers
        return r

class Matrix(DictObject):
    pass

def apply(m, (x,y)):
    return ( m.a*x + m.b*y + m.tx
           , m.c*x + m.d*y + m.ty )

def invert(m):
    s = 1 / (m.a*m.d - m.b*m.c)
    return Matrix( a=s*m.d
                 , b=-s*m.b
                 , c=-s*m.c
                 , d=s*m.a
                 , tx=-s*m.d*m.tx + s*m.b*m.ty
                 , ty= s*m.c*m.tx - s*m.a*m.ty
                 )

def rotate(t):
    return Matrix( a=math.cos(t)
                 , b=-math.sin(t)
                 , c=math.sin(t)
                 , d=math.cos(t)
                 , tx=0
                 , ty=0
                 , )

def set_matrix(elem, e):
    m = Matrix()

    point = firstElement(e, 'Point')
    if point:
        # transformationPoint
        m.x = getAttribute(point, 'x', float)
        m.y = getAttribute(point, 'y', float)
    else:
        m.x = m.y = float()

    matrix = firstElement(e, 'Matrix')
    if matrix:
        m.a  = getAttribute(matrix, 'a',  float, 1.0)
        m.b  = getAttribute(matrix, 'b',  float, 0.0)
        m.c  = getAttribute(matrix, 'c',  float, 0.0)
        m.d  = getAttribute(matrix, 'd',  float, 1.0)
        m.tx = getAttribute(matrix, 'tx', float, 0.0)
        m.ty = getAttribute(matrix, 'ty', float, 0.0)
    else:
        m.a = m.d = 1.0
        m.b = m.c = m.tx = m.ty = 0.0

    elem.matrix = m

    # 反转 仿射变换
    elem.transfromValue = gettransfromvalue(m)
    elem.rotation = getangle(m)
    elem.scaleValue = getscalevalue(m, elem.rotation)

_all_names = defaultdict(set)
def name_collide_detect(symname, instanceName):
    if instanceName in _all_names[symname]:
        print '重名：', symname, instanceName
    _all_names[symname].add(instanceName)

def load_light_info(root, layerElem):
    frameElem = filter(lambda fe: firstElement(fe, 'elements').childNodes, layerElem.getElementsByTagName('DOMFrame'))[0]
    index = getAttribute(frameElem, 'index', int)

    elm = firstElement(frameElem, 'elements')
    e = filter(isElement, elm.childNodes)[0]

    elem = Element()
    set_matrix(elem, e)

    set_matrix(elem, e)
    uncleaned_libName = e.getAttribute('libraryItemName')
    elem.libName = filename_clean(uncleaned_libName)
    sym = load_symbol(root, uncleaned_libName)

    (minX, minY), (width, height) = sym.boundingBox
    elem.size = (width, height)
    elem.scaleValue = (1,1)
    x, y = getposition(*((elem.matrix.tx, elem.matrix.ty) + elem.scaleValue + (0,0) + (elem.rotation,)))
    return index, x, y

symbol_cache = {}
def load_symbol(root, uncleaned_name):
    name = filename_clean(uncleaned_name)

    if name in symbol_cache:
        return symbol_cache[name]

    symbol = Symbol()
    
    if uncleaned_name == "png/image 1.png":
        print("symbol = " + uncleaned_name)
    symbolElem = minidom.parse(pathjoin(root, 'LIBRARY', uncleaned_name+'.xml'))

    isButton = symbolElem.firstChild.getAttribute('symbolType')=='button'

    layerElems = symbolElem.firstChild.getElementsByTagName('DOMLayer')
    layerElems.reverse()
    for layerElem in layerElems:
        layerName = layerElem.getAttribute('name')
        if layerElem.getAttribute('name')=='npc':
            continue

        if layerElem.getAttribute('name')=='light':
            # 光效层
            #symbol.lightFrame, symbol.lightX, symbol.lightY = load_light_info(root, layerElem)
            continue
        
        isMask = layerElem.getAttribute('name')=='mask'
        layer = Layer()
        layer.name = layerName
        if layerElem.getAttribute('name')=='target':
            symbol.anis.append(layer)
        else:
            symbol.layers.append(layer)

        for frameElem in layerElem.getElementsByTagName('DOMFrame'):

            index = getAttribute(frameElem, 'index', int)
            if isButton:
                if index==1:
                    continue
                elif index>1:
                    index -= 1

            keyframe = Keyframe()
            layer.keyframes.append(keyframe)

            keyframe.startFrame = index

            if frameElem.getAttribute('tweenType'):
                keyframe.isMotion = getAttribute(frameElem, 'tweenType')=='motion';

            if not isButton and frameElem.getAttribute('duration'):
                keyframe.duration = int(frameElem.getAttribute('duration'))
            
            # 取得脚本
            elm = frameElem.getElementsByTagName('Actionscript')            
            if elm and len(elm) > 0:
                elm = elm[0].getElementsByTagName('script')
                if elm and len(elm) > 0:
                    node = elm[0];
                    keyframe.script = ""
                    for node in node.childNodes:
                        if node.nodeType in ( node.TEXT_NODE, node.CDATA_SECTION_NODE):
                            keyframe.script = keyframe.script + node.data
                

            elm = firstElement(frameElem, 'elements')
            if elm:
                elements = filter(isElement, elm.childNodes)
            else:
                elements = []

            for e in elements:
                elem = Element()

                if index==1 and e.getAttribute('name'):
                    name_collide_detect(uncleaned_name, e.getAttribute('name'))

                '''
                elem.type = {
                    'DOMBitmapInstance': BITMAP,
                    'DOMShape': RECT,
                    'DOMSymbolInstance': MOVIECLIP,
                    'DOMStaticText': TTFTEXT,
                    'DOMDynamicText': TTFTEXT,
                }[e.tagName]
                '''
                if elemTypes.get(e.tagName, None) == None:
                    print "can't find type %s in %s" % (e.tagName,uncleaned_name)
                    continue
                elem.type = elemTypes[e.tagName];

                if isMask:
                    if elem.type==MOVIECLIP:
                        elem.type=FRAME
                    else:
                        continue

                if elem.type == BITMAP:
                    elem.libName = os.path.basename(e.getAttribute('libraryItemName'))

                    set_matrix(elem, e)

                    elem.size = getimagesize(root, filename_clean(e.getAttribute('libraryItemName')))
                    elem.minPos = (-elem.size[0]/2.0, -elem.size[1]/2.0)
                    elem.position = getposition(*((elem.matrix.tx, elem.matrix.ty) + elem.scaleValue + elem.size + (elem.rotation,)))
    
                    elem.instanceName = e.getAttribute('name') or 'bitmap'
                    set_alpha(elem, e)
                    set_color(elem, e)

                elif elem.type in (MOVIECLIP, FRAME):
                    set_matrix(elem, e)
                    uncleaned_libName = e.getAttribute('libraryItemName')
                    elem.libName = filename_clean(uncleaned_libName)
                    sym = load_symbol(root, uncleaned_libName)
                    if not sym:
                        continue

                    if elem.type == FRAME:
                        (minX, minY), (width, height) = sym.boundingBox
                        scaleX, scaleY = elem.scaleValue
                        elem.minPos = (minX*scaleX, minY*scaleY)
                        elem.size = (abs(width*scaleX), abs(height*scaleY))
                        elem.scaleValue = (1,1)
                    else:
                        elem.minPos, elem.size = sym.boundingBox

                    elem.position = getposition(*((elem.matrix.tx, elem.matrix.ty) + elem.scaleValue + (0,0) + (0,)))
                    
                    if elem.type == FRAME:
                        elem.instanceName = e.getAttribute('name') or 'frame'
                    else:
                        elem.instanceName = e.getAttribute('name')
                        set_alpha(elem, e)
                        set_color(elem, e)

                elif elem.type == TTFTEXT:
                    elem.instanceName = e.getAttribute('name') or 'text'
                    set_matrix(elem, e)
                    elem.size = (getAttribute(e, 'width', float)+4, getAttribute(e, 'height', float)+4)

                    elem.matrix.tx += getAttribute(e, 'left', float)

                    elem.minPos = (-elem.size[0]/2.0, -elem.size[1]/2.0)
                    elem.position = getposition(*((elem.matrix.tx, elem.matrix.ty) + elem.scaleValue + elem.size + (elem.rotation,)))

                    elem.text = ''
                    for _e in e.getElementsByTagName('textRuns')[0].getElementsByTagName('DOMTextRun'):
                        txtNode = _e.getElementsByTagName('characters')[0].firstChild
                        elem.text += txtNode and txtNode.wholeText or ''

                    txtElem = e.getElementsByTagName('textRuns')[0].getElementsByTagName('DOMTextRun')[0]
                    attrElem = txtElem.getElementsByTagName('textAttrs')[0].getElementsByTagName('DOMTextAttrs')[0]
                    elem.fontSize = attrElem.getAttribute('size')
                    elem.color = attrElem.getAttribute('fillColor')
                    alignment = getAttribute(attrElem, 'alignment', str, 'left')
                    elem.alignment = {
                        'left': ALIGNMENT_LEFT,
                        'center': ALIGNMENT_CENTER,
                        'right': ALIGNMENT_RIGHT,
                    }[alignment]

                elif elem.type == RECT:
                    edges = edgeElem = e.getElementsByTagName('edges')[0].getElementsByTagName('Edge')[0].getAttribute('edges')
                    points2 = re.split(r'[|!]', edges)
                    print name
                    #print points2                    
                    #points = [map(lambda s: int(s) if s[-2]!='S' else int(s[:-2]), p.split(' ', 1)) for p in points if p]
                    #print points
                    points = []
                    for i in range(0, len(points2)):
                        if points2[i] == None or len(points2[i]) == 0:
                            continue
                        s = points2[i].split(' ')
                        try:                        
                            if s[0][-2] == 'S':
                                s[0] = float(s[0:-2])
                            else:
                                s[0] = float(s[0])
                        except:
                            s[0] = float(s[0])
                        try:
                            if s[1][-2] == 'S':
                                s[1] = float(s[1][0:-2])
                            else:
                                s[1] = float(s[1])
                        except:
                            s[1] = float(s[1])
                        
                        points.append((s[0], s[1]))
                    #print points  

                    minX = min(p[0] for p in points)/20.0
                    minY = min(p[1] for p in points)/20.0
                    maxY = max(p[1] for p in points)/20.0
                    maxX = max(p[0] for p in points)/20.0

                    elem.size = (maxX-minX, maxY-minY)
                    elem.minPos = (minX, minY)
                    elem.position = getposition(minX, minY, 1, 1, elem.size[0], elem.size[1], 0)

                    try:
                        colorElem = e.getElementsByTagName('fills')[0].getElementsByTagName('FillStyle')[0].getElementsByTagName('SolidColor')[0]
                    except:
                        continue
                    else:
                        elem.color = colorElem.getAttribute('color') or '#000000'
                        elem.alpha = int(round(255*(float(colorElem.getAttribute('alpha') or 1))))
                else:
                    print 'unsupported type', tagName
                    continue

                keyframe.elements.append(elem)

    # 计算符号的size和anchorpoint
    boxes = []
    for l in symbol.layers:
        try:
            kf = l.keyframes[0]
        except IndexError:
            continue
        for e in kf.elements:
            boxes.append(parentBoundingBox(e))

    ((x,y), (w,h)) = combineBoxes(boxes)

    if w<=0 or h<=0:
        print u'无效元件%s'%uncleaned_name, w,h
        print boxes
        return

    #symbol.anchorPoint = (-x/w, -y/h)
    #symbol.size = (w,h)
    symbol.boundingBox = ((x,y), (w,h))
    symbol_cache[name] = symbol
    return symbol

def parentBoundingBox(e):
    ((x,y), (w,h)) = e.boundingBox()
    sx,sy = e.scaleValue
    if sx<0:
        x = (x+w)*sx
    else:
        x *= sx
    if sy<0:
        y = (y+h)*sy
    else:
        y *= sy
    w = abs(w*sx)
    h = abs(h*sy)
    px, py = e.position
    return ( (px+x, py+y), (w, h) )

def parsefla(root):
    symbol_cache.clear()
    try:
    	dom = minidom.parse(pathjoin(root, 'DOMDocument.xml'))
    except IOError:
    	return
    
    frameRate = 24;
    elems = dom.getElementsByTagName('DOMDocument');
    if elems:
        s = elems[0].getAttribute('frameRate');        
        if len(s) > 0:
            frameRate = int(s);
                
    for each in dom.getElementsByTagName('Include'):
        symbol = load_symbol(root, os.path.splitext(each.getAttribute('href'))[0])
        if symbol:
            symbol._frameRate = frameRate

    d = {}
    import anim_pb2
    msg_anim = anim_pb2.Anim()
    for name, v in symbol_cache.items():
        if name.startswith('outside'):
            continue
        d[name] = v.to_plist()
        msg_sym = msg_anim.symbols.add()
        dump_symbol(name, v, msg_sym)

    return {'libItemDict': d}, msg_anim

def dumpplist(d, f):
    import plistlib
    plistlib.writePlist(d, f)

def dumpmsg(d, f):
    s = d.SerializeToString()
    f = open(f, 'wb')
    f.write(s)
    f.close()

def packimages(src, dst):
    import shutil
    img_exts = ['.png', '.jpg']
    for root, dirs, files in os.walk(os.path.join(src, 'LIBRARY')):
    	if root.endswith('LIBRARY'):
    		continue
        for f in files:
            clean_f = f.replace('\\', '/')
            ext = os.path.splitext(f)[1]
            if ext not in img_exts:
                continue
            # copy file TODO pack to texture
            shutil.copyfile(os.path.join(root, f), os.path.join(dst, 'images', os.path.basename(clean_f)))

def dump_symbol(name, sym, msg_sym):
    msg_sym.name = name
    (msg_sym.boundingBox.x, msg_sym.boundingBox.y), (msg_sym.boundingBox.w, msg_sym.boundingBox.h) = sym.boundingBox;

    msg_sym.frameRate = sym._frameRate
    msg_sym.frameCount = max(kf.startFrame+kf.duration for l in sym.layers for kf in l.keyframes)

    for iLayer, layer in enumerate(sym.layers):
        dump_layer(layer, msg_sym.layers.add());
    for iLayer, layer in enumerate(sym.anis):
        dump_ani(layer, msg_sym.anis.add());    
        
def dump_layer(layer, msg_layer):
    for kf in layer.keyframes:
        msg_kf = msg_layer.keyframes.add()
        msg_kf.startFrame = kf.startFrame
        if kf.isMotion:
            msg_kf.isMotion = True
        if kf.script and len(kf.script) > 0:
            msg_kf.script = kf.script
        if kf.duration!=1:
            msg_kf.duration = kf.duration

        for elem in kf.elements:
            msg_elem = msg_kf.elements.add()
            msg_elem.type = elem.type;
            msg_elem.position.x, msg_elem.position.y = elem.position;
            (msg_elem.boundingBox.x, msg_elem.boundingBox.y), (msg_elem.boundingBox.w, msg_elem.boundingBox.h) = elem.boundingBox();

            if elem.get('libName'):
                msg_elem.libName = elem.libName;
            if elem.get('instanceName'):
                msg_elem.instanceName = elem.instanceName
            if elem.get('rotation'):
                msg_elem.rotation = elem.rotation
            if elem.get('transformValue'):
                msg_elem.transformValue = elem.transformValue
            if elem.get('scaleValue'):
                msg_elem.scaleValue.x,msg_elem.scaleValue.y = elem.scaleValue
            if elem.get('alpha')!=None and elem.get('alpha')!=255:
                msg_elem.alpha = elem.alpha
            if elem.get('color'):
                msg_elem.color.r, msg_elem.color.g, msg_elem.color.b = parsecolor(elem.color)
            if elem.get('text'):
                msg_elem.text = elem.text
            if elem.get('fontSize'):
                msg_elem.fontSize = int(elem.fontSize)
            if elem.get('alignment'):
                msg_elem.alignment = int(elem.alignment)
                
def dump_ani(layer, msg_layer):
    for kf in layer.keyframes:
        msg_kf = msg_layer.keyframes.add()
        msg_kf.startFrame = kf.startFrame        
        if kf.isMotion:
            msg_kf.isMotion = True
        if kf.script and len(kf.script) > 0:
            msg_kf.script = kf.script
        if kf.duration!=1:
            msg_kf.duration = kf.duration
        if len(kf.elements) > 0:
            msg_kf.position.x, msg_kf.position.y = kf.elements[0].position;
        else:
            msg_kf.position.x = 0;
            msg_kf.position.y = 0;

if __name__ == '__main__':
    if len(sys.argv)>2:
        inputroot = sys.argv[1]
        outputroot = sys.argv[2]
    else:
        inputroot = '../../sv_fla'
        outputroot = '../mc'

    for d in os.listdir(inputroot):

        if d.endswith('.svn'):
            continue
        
        current_filename = d

        d = os.path.join(inputroot, d)
        if not os.path.isdir(d):
            continue

        print u'解析文件', d

        #temppath = os.tempnam('/tmp', 'FLA')
        #if not unzipto(absolute, temppath):
        #    print u'错误：解压 %s 失败！'%args.src
        #    sys.exit(1)

        bigdict, msg_anim = parsefla(d)
        if not bigdict:
        	continue

        # 使用flash自带功能搞定
        # packimages(d, outputroot)

        # dump protocol msg
        msgdestpath = os.path.join(outputroot, current_filename+'.anim')
        dumpmsg(msg_anim, msgdestpath)
        print 'write', msgdestpath

        # dump animxml
        destpath = os.path.join(outputroot, current_filename+'.animxml')
        dumpplist(bigdict, destpath)
        print 'write', destpath

        if False:
            destpath = os.path.join(outputroot, os.path.splitext(f)[0]+'.animxml.json')
            result = jsondump(bigdict, file(destpath, 'w'), indent=4)
            print 'write', destpath

    # 生成索引
    #print u'生成索引'
    #import genindex
    #genindex.main(outputroot)
