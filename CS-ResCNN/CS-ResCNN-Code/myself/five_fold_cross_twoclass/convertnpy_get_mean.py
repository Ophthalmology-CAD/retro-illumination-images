#!/usr/bin/env python
#coding=utf-8
'''
将生成的均值文件转换为npy的形式
'''

import PIL
import Image
import sys
import time
import os
import numpy as np
from matplotlib import pyplot as plt 

start = time.time()

# Make sure that caffe is on the python path
caffe_root = '/home/jie/caffe/caffe-master/'  
sys.path.insert(0, caffe_root + 'python')

import caffe

#source = caffe_root + 'myself/python_okornotok/okornotok_result/mnist_test_lmdb_mean.binaryproto'
#des = caffe_root + 'myself/python_okornotok/okornotok_result/mnist_test_lmdb_mean.npy'

#source = caffe_root + 'myself/get_mean/mnist_train_lmdb_mean.binaryproto'
#des = caffe_root + 'myself/get_mean/mnist_train_lmdb_mean.npy'

#source = '/home/jie/caffe/cnn_auto-cut_data/shifouzhongyang/5/mnist_train_lmdb_mean.binaryproto'
#des = '/home/jie/caffe/cnn_auto-cut_data/shifouzhongyang/5/mnist_train_lmdb_mean.npy'

source = '/home/jie/caffe/caffe-master/creatdata/cnn_yuanshi_data/是否正常/9/mnist_train_lmdb_mean.binaryproto'
des = '/home/jie/caffe/caffe-master/creatdata/cnn_yuanshi_data/是否正常/9/mnist_train_lmdb_mean.npy'



#source = caffe_root + 'myself/get_mean/mnist_test_lmdb_mean.binaryproto'
#des = caffe_root + 'myself/get_mean/mnist_test_lmdb_mean.npy'

blob = caffe.proto.caffe_pb2.BlobProto()
data = open( source , 'rb' ).read()
blob.ParseFromString(data)
mean_arr = caffe.io.blobproto_to_array(blob)
arr = np.array( mean_arr )
#arr = np.array( caffe.io.blobproto_to_array(blob) )
out = arr[0]
np.save( des , out )


mean_test1 = mean_arr[0].mean(1).mean(1)
mean_zero=[0,0,0]
mean_tmp=np.array(mean_zero)
mean_tmp[0]=int(round(mean_test1[0]))
mean_tmp[1]=int(round(mean_test1[1]))
mean_tmp[2]=int(round(mean_test1[2]))
print 'mean:',mean_tmp

