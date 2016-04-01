import os, sys
from PIL import Image
from StringIO import StringIO

summary_origin_size = 0
summary_new_size = 0
compress_extension = '.pkm'

ignore_files = set(['gameUI_1.png', 'gameUI_2.png', 'login_2.png', 'gameUI_4.png'])#, 'b6.png', '10005_3.png', '10006_3.png', '10010_3.png', '10014_3.png', 'all.png'])

def save_alpha(img):
    return img.tostring()

def save_alpha_jpg(img):
    stream = StringIO()
    img.save(stream, 'JPEG', optimize=1, quality=40)
    return stream.getvalue()

def convert(filename):
    global summary_origin_size, summary_new_size

    if os.path.basename(filename) in ignore_files:
        return

    output = filename+compress_extension

    # check timestamp
    if not os.path.exists(output) or os.path.getmtime(filename) >= os.path.getmtime(output):
        img = Image.open(filename)
        img.load()
        width, height = img.size
        try:
            idx = img.getbands().index('A')
        except ValueError:
            alphacontent = ''
        else:
            alpha = img.split()[idx]
            alphacontent = save_alpha_jpg(alpha)
            #assert len(alphacontent)==width*height, 'invalid alpha size'

        cmd = 'etcpack %s %s %s' % (filename, output, '> /dev/null' if os.name!='nt' else '> $null')
        if os.system(cmd) !=0:
            sys.exit(1)

        if alphacontent:
            f = open(output, 'ab')
            f.write(alphacontent)
            f.flush()
            f.close()

        origin_size = os.path.getsize(filename)
        new_size = os.path.getsize(output)

        width4 = width + (4 - width%4) % 4
        height4 = height + (4 - height%4) % 4
        if alphacontent:
            assert new_size==len(alphacontent)+width4*height4*3/6+16, 'invalid file size %s %d %d' % (filename, new_size, width4*height4+width4*height4*3/6+16)
        else:
            assert new_size==width4*height4*3/6+16, 'invalid file size %s %d %d' % (filename, new_size, width4*height4*3/6+16)

    origin_size = os.path.getsize(filename)
    new_size = os.path.getsize(output)

    print '%.3f%%\t%s -> %s' % (float(new_size)*100/origin_size, filename, output)

    summary_origin_size += origin_size
    summary_new_size += new_size

if __name__ == '__main__':
    import os, sys
    if len(sys.argv)>1:
        p = sys.argv[1]
    else:
        p = '..'
    for root, dirs, files in os.walk(p, followlinks=True):
        for f in files:
            if f.endswith('.png') or f.endswith('.PNG'):
                convert(os.path.join(root, f))
    print '%.3f%%\tavarage' % (float(summary_new_size)*100/summary_origin_size)
