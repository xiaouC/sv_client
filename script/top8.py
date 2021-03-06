#!/usr/bin/env python
# coding=utf-8

import os, sys
from PIL import Image
import csv

dirs = [ '../mc', '../images' ]
ignore_files = set( ['default.png', 'lollogin.png', '60420.beijing.jpg', 'lollogin_2.png','launch.png','5NgameUI.png','5NgameUI_010.png','5NgameUI_019.png','60415.png','Nb112.png','Nb113.png','60600_1.png','60600_2.png','10200_0_21.jpg','10200_0_22.jpg','10200_0_23.jpg','10200_0_24.jpg','10201_1.jpg','10201_2.jpg','10201_3.jpg','10201_4.jpg','10201_5.jpg','10200.png','10201.png','60001.png','60002.png','60056.png','60067.png','60088.png','60096.png','60103.png','60150.png','60150_2.png','60150_3.png','60150_4.png','60150_5.png','60150_6.png','60163.png','60414.png','60410.png','60412.png','60415.png','60618.png','60617.png','60714_1.png','60714_2.png','60715_1.png','60715_2.png','60717_1.png','60717_2.png','60718_1.png','60718_2.png','60719_1.png','60719_2.png','60720_1.png','60720_2.png','60721_1.png','60721_2.png','60722_1.png','60722_2.png','204041.png','204042.png','204043.png','204681.png','204661.png','10251_1.jpg','10251_2.jpg','b1_5x.png','5icon_0001.png','5icon_0002.png','5icon_0003.png','5icon_0004.png','5icon_0005.png','5icon_0006.png','42001.png','42002.png','42003.png','42004.png','42005.png','42006.png','5Nb_001.jpg','60603.png','60602.png','60605.png','60609.png','60604.png','60616.png','60610.png','60612.png','5Nb_1414_1.jpg','5NgameUI_1024.png','5Nb_077.png', '5Nb_2121_1.jpg'] )


# 转换文件 
def convert( filename ) :

    # 判断文件是否需要忽略
    if os.path.basename( filename ) in ignore_files :
        return

    print( "convert file name ",filename )

    # 新文件后缀名 
    output = filename + '.p8'


    # check timestamp 不再用文件修改时间作为转换依据
    # if not os.path.exists( output ) or os.path.getmtime( filename ) >= os.path.getmtime( output ) :
    img = Image.open(filename)
    img.load()
    if img.mode == "P":
        print 'img mode is p', filename
        # 如果文件已经是P8模式，重命名为p8后缀
        os.system( 'cp %s %s' % ( filename, filename + '.p8' ) )
        #os.rename(filename,filename + '.p8')
        return 

    # 执行转换 
    cmd = 'pngquant %s --force --ext  ".png.p8" %s' % ( filename, '> /dev/null' if os.name != 'nt' else '> $null' )
    if os.system( cmd ) != 0 :
        sys.exit( 1 )


# 转换目录
def convert_dir( dir ) :
    for root, sub_dirs, files in os.walk( dir, followlinks = True ) :
        for f in files :
            #if f.endswith( '.png' ) or f.endswith( '.PNG' ) or f.endswith( '.jpg' ) or f.endswith( '.JPG' ):
            if f.endswith( '.png' ) or f.endswith( '.PNG' ):
                convert( os.path.join( root, f ) )

def rm_unused_p8_dir( dir ):
    for root, sub_dirs, files in os.walk( dir, followlinks = True ) :
        for f in files :
            if f.endswith( '.p8' ):
                temp_file = f[:-3]

                # 如果这个 p8 对应的原文件已经不存在了，删除
                if not os.path.exists( os.path.join( root, temp_file ) ):
                    os.system( 'rm %s' % os.path.join( root, f ) )

                # 如果这个 p8 对应的原文件不需要压缩的话，删除
                if os.path.basename( temp_file ) in ignore_files :
                    os.system( 'rm %s' % os.path.join( root, f ) )

# 文件md5
def file_md5_size(f):
    import md5
    c = open(f, 'rb').read()
    return md5.md5(c).hexdigest(), len(c)


# 是否是相同文件
def is_same_file(filename, files_md5):
    md5, size = file_md5_size(filename)
    if filename not in files_md5 :
        print "files_md5[filename] is null ................... : ", filename 
        return False
    return files_md5[filename] == md5


# 写入md5
def write_file_md5(dirs):
    writer = csv.writer(file('filelist_p8','wb'))
    for dir in dirs :
        #print 'directory :', dir
        for root, sub_dirs, files in os.walk( dir, followlinks = True ) :
            for f in files :
                if f.endswith( '.png' ) or f.endswith( '.PNG' ):
                    abs_filename = os.path.join(root, f)
                    md5, size = file_md5_size(abs_filename)

                    #print 'abs_filename :', abs_filename 
                    writer.writerow([abs_filename,md5,size])

if __name__ == '__main__':
    files_md5 = {}

    # 如果文件不存在，先创建该文件，写入文件md5
    if not os.path.isfile('filelist_p8'):
        write_file_md5(dirs)
        for dir in dirs :
            print 'directory :', dir

            # 执行文件转换 
            convert_dir( dir )
    else:
        reader = csv.reader(file('filelist_p8','rb'))
        # 获得文件md5的集合 
        for name,md5,size in reader:
            files_md5[name] = md5

        for dir in dirs :
            print 'directory :', dir
            for root, sub_dirs, files in os.walk( dir, followlinks = True ) :
                for f in files :
                    # 查找png后缀的文件 
                    if f.endswith( '.png' ) or f.endswith( '.PNG' ):
                        # 判断当前文件的 md5 和历史版本是否一致, 如果一致，则不执行转换 
                        if is_same_file(os.path.join(root, f),files_md5):
                            continue
                        
                        #执行转换
                        print 'new file ' , f 
                        convert( os.path.join( root, f ) )
  
    # 删掉已经没有引用的 p8 
    for dir in dirs :
        rm_unused_p8_dir( dir )

    write_file_md5(dirs)

    print 'convert completed!'
