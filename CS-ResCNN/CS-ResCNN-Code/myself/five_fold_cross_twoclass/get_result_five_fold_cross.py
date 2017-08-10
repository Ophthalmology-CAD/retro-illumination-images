# -*-  encoding:utf-8  -*-
def get_result_five_fold_cross(normal_file,recurrence_file,surgery_file,image,cnn,train_caffemodel):
	import numpy as np
	import matplotlib.pyplot as plt
	import os,types

	caffe_root = '/home/shiyan/caffe-master-cost-sensitive/'
	import sys
	sys.path.insert(0,caffe_root+'python')

	import caffe


	MODEL_FILE = caffe_root+'myself/'+cnn+'/deploy-50.prototxt'
	PRETRAINED = caffe_root+'myself/'+cnn+'/caffe_alexnet_train_'+train_caffemodel+'_iter_2000.caffemodel'+''

	MEAN_FILE = caffe_root+'myself/'+cnn+'/mnist_train_lmdb_mean.binaryproto'

	# Open mean.binaryproto file

	blob = caffe.proto.caffe_pb2.BlobProto()
	data = open(MEAN_FILE , 'rb+').read()
	blob.ParseFromString(data)
	mean_arr = caffe.io.blobproto_to_array(blob)
	#mean1 = mean_arr[0]
	#mean_test=mean_arr[0].mean(1)
	mean_test1 = mean_arr[0].mean(1).mean(1)
	mean_zero=[0,0,0]
	mean_tmp=np.array(mean_zero)
	mean_tmp[0]=int(round(mean_test1[0]))
	mean_tmp[1]=int(round(mean_test1[1]))
	mean_tmp[2]=int(round(mean_test1[2]))


	# Initialize NN
	# Initialize NN
	net = caffe.Classifier(MODEL_FILE, PRETRAINED,


						   image_dims=(128,128),

						   #mean=np.load(caffe_root+'myself/'+cnn+'/'+model+'/mnist_train_lmdb_mean.npy').mean(1).mean(1),
						   #mean = np.array([mean0,mean1,mean2]),
						   mean = mean_tmp,
						   #mean= mean_arr[0].mean(1).mean(1),
						  # mean=np.load(caffe_root + 'myself/python_okornotok/okornotok_result/mnist_train_lmdb_mean.npy').mean(1).mean(1),

						   #input_scale=255,



						   raw_scale=255,
						   channel_swap=(2,1,0)
							)

	net.blobs['data'].reshape(1,3,112,112)
	#test_file1 = "/home/jie/caffe/caffe-master/myself/python_okornotok/okornotok5-5/other-5/test"
	#test_file2 = "/home/jie/caffe/caffe-master/myself/python_okornotok/okornotok5-5/ok-5/test"
	#test_file3 = "/home/jie/caffe/caffe-master/myself/python_okornotok/okornotok/train/ok"

	#test_recurrence=caffe_root+'myself/test_data/'+recurrence_file+'/'+image
	#test_normal=caffe_root+'myself/test_data/'+normal_file+'/'+image
	#test_surgery=caffe_root+'myself/test_data/'+surgery_file+'/'+image

	test_recurrence=caffe_root+'myself/hongfan-twoclass-1-10data-128/'+recurrence_file+'/'+image
	#test_normal=caffe_root+'myself/twoclass_test_data/'+normal_file
	test_surgery=caffe_root+'myself/hongfan-twoclass-1-10data-128/'+surgery_file+'/'+image

	sum_surgery=0
	error_surgery_number=0
	list_surgery0=[]
	list_surgery1=[]
	list_surgery2=[]
	surgeryp=[]
	for root,dirs,files in os.walk(test_surgery):
		for file in files:
			#print file
			IMAGE_FILE = os.path.join(root,file)
			prediction = net.predict([caffe.io.load_image(IMAGE_FILE)],oversample=True) #prediction = net.predict([caffe.io.load_image(IMAGE_FILE)],oversample=False)
			print 'predicted class:',prediction[0].argmax()
			sum_surgery=sum_surgery+1
			surgeryp.append(prediction)
			if prediction[0].argmax() == 0:
				error_surgery_number = error_surgery_number+1
				list_surgery0.append(file+'\t'+'predicted class:'+str(prediction[0].argmax())+'\t'+'predicted:'+str(prediction[0]))
			if prediction[0].argmax() == 1:
				list_surgery1.append(file+'\t'+'predicted class:'+str(prediction[0].argmax())+'\t'+'predicted:'+str(prediction[0]))
	list_surgery2.append('sum_surgery:'+str(sum_surgery)+'\t'+'error_surgery_number:'+str(error_surgery_number)+'\t'+'the surgery accuracy is:' + str(float((sum_surgery)-(error_surgery_number))/float(sum_surgery)))
			#print("Predicted class probe argmax is #{}.".format(out['prob'].argmax()))

	sum_other=0
	error_other_number=0
	list_other0=[]
	list_other1=[]
	list_other2=[]
	otherp=[]
	for root,dirs,files in os.walk(test_recurrence):
		for file in files:
			#print file
			IMAGE_FILE = os.path.join(root,file)
			prediction = net.predict([caffe.io.load_image(IMAGE_FILE)],oversample=True) #prediction = net.predict([caffe.io.load_image(IMAGE_FILE)],oversample=False)
			#print 'image: ',file
			print 'predicted class:',prediction[0].argmax()
			sum_other=sum_other+1
			otherp.append(prediction)
			if prediction[0].argmax() == 0:
				list_other0.append(file+'\t'+'predicted class:'+str(prediction[0].argmax())+'\t'+'predicted:'+str(prediction[0]))
			if prediction[0].argmax() == 1:
				error_other_number = error_other_number+1
				list_other1.append(file+'\t'+'predicted class:'+str(prediction[0].argmax())+'\t'+'predicted:'+str(prediction[0]))
	list_other2.append('sum_recurrence:'+str(sum_other)+'\t'+'error_recurrence_number:'+str(error_other_number)+'\t'+'the other accuracy is:' + str(float((sum_other)-(error_other_number))/float(sum_other)))
			#print("Predicted class probe argmax is #{}.".format(out['prob'].argmax()))
	#print prediction[0]
	#print 'sum_other is: ',sum_other
	#print 'error_other_number is:',error_other_number



	# print '******************************************'
	# print 'sum_other is: ',sum_other
	# print 'error_other_number is:',error_other_number
	# print 'sum_ok is: ',sum_ok
	# print 'error_ok_number is:',error_ok_number
	# print '*****************************************'
	accuracy = float((sum_other+sum_surgery)-(error_other_number+error_surgery_number))/float(sum_other+sum_surgery)
	print 'the accuracy is:', accuracy*100
	list_surgery2.append('the total accuracy is:' + str(accuracy))

	#FN+TP=P positive other, TN+FP=N negative ok.
	RESULT_FILE=caffe_root+'myself/'+cnn+'/caffe_alexnet_train_'+train_caffemodel+'.txt'
	#TEST_FILE='/home/jie/桌面/five-fold-cross/result_cnn/'+cnn+'/probability/'+model+'.txt'
	#RESULT_FILE='/home/jie/桌面/five-fold-cross/result_cnn/five-fold-liulin/'+model+'.txt'
	#TEST_FILE='/home/jie/桌面/five-fold-cross/result_cnn/five-fold-liulin/probability/'+model+'.txt'

	file_object = open(RESULT_FILE, 'w')
	file_object.writelines('ERROR_RECURRENCE\n')
	for i in list_other0:
		file_object.writelines(i+'\n')
	for i in list_other1:
		file_object.writelines(i+'\n')
	for i in list_other2:
		file_object.writelines(i+'\n')
	file_object.writelines('-------------------------------------------------------\n')
	file_object.writelines('ERROR_SUGERY\n')
	for i in list_surgery0:
		file_object.writelines(i+'\n')
	for i in list_surgery1:
		file_object.writelines(i+'\n')
	for i in list_surgery2:
		file_object.writelines(i+'\n')
	file_object.close()

        	#print 'prediction shape:',prediction[0].shape
		#plt.plot(prediction[0])
		#print "predicted class:%s"%(IMAGE_FILE)
		#input_image = caffe.io.load_image(IMAGE_FILE)
		#print input_image
		#prediction class


#caffe.set_mode_gpu()
#caffe.set_phase_test()

# input preprocessing: 'data' is the name of the input blob == net.inputs[0]
#net.set_mean('data', mean_arr[0]) # ImageNet mean
#net.set_raw_scale('data', 255)  # the reference model operates on images in [0,255] range instead of [0,1]
#net.set_channel_swap('data', (2,1,0))  # the reference model has channels in BGR order instead of RGB



#caffe.set_mode_cpu()

#net = caffe.Net(MODEL_FILE,
#                PRETRAINED,
#                caffe.TEST)

# input preprocessing: 'data' is the name of the input blob == net.inputs[0]
#transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})
#transformer.set_transpose('data', (2,0,1))
#net.set_mean('data',mean_arr[0])

#transformer.set_mean('data', mean_arr[0]) # mean pixel

#transformer.set_mean('data', np.load(caffe_root + 'myself/python_okornotok/okornotok_result/ilsvrc_mean.npy').mean(1).mean(1)) # mean pixel
#transformer.set_mean('data', np.load(caffe_root + 'myself/python_okornotok/okornotok_result/mean.npy').mean(1).mean(1)) # mean pixel

#mean_file = np.array([72,65,60])
#transformer.set_mean('data', mean_file)

#transformer.set_raw_scale('data', 255)  # the reference model operates on images in [0,255] range instead of [0,1]
#transformer.set_channel_swap('data', (2,1,0))  # the reference model has channels in BGR order instead of RGB






