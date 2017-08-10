#!/usr/bin/env sh

TOOLS=./build/tools

for i in 1 2 3 4 5 6 7 8 9 10 11 12
	sed -i 's/caffe_alexnet.*/caffe_alexnet_train_'$i'"/g' ./myself/fine-ResNet-50/resnet_50_solver.prototxt
	sed -i 's/pos_mult:.*/pos_mult: '$i'/g' ./myself/fine-ResNet-50/resnet_50.prototxt
	GLOG_logtostderr=1 $TOOLS/caffe train --solver=./myself/fine-ResNet-50/resnet_50_solver.prototxt --weights ./myself/fine-ResNet-50/ResNet-50-model.caffemodel -gpu 0,1,2,3
	echo "Done."
	done
