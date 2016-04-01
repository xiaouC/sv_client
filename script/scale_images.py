#!/usr/bin/python
import os
import Image

def ensure_dir(f):
    d = os.path.dirname(f)
    if not os.path.exists(d):
        os.makedirs(os.path.abspath(d))

def scale(f, outf, ratio):
    im = Image.open(f)
    w, h = im.size
    im.thumbnail( (int(round(w*ratio)), int(round(h*ratio))), Image.ANTIALIAS )
    ensure_dir(outf)
    im.save(outf)

def main(d, target):
    for dd in os.listdir(d):
        root = os.path.join(d, dd)
        f = os.path.join(root, 'scale.txt')
        try:
            ratio = float(open(f).read())
        except IOError:
            ratio = 0.7
        print root, ratio
        for ddd, dirs, files in os.walk(root):
            for f in files:
                if f.endswith('.png'):
                    print f
                    path = os.path.join(root, ddd, f)
                    outf = os.path.join(target, dd, ddd, f)
                    scale(path, outf, ratio)

if __name__ == '__main__':
    main('../', '.')
