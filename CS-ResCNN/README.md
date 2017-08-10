## Usage Instructions:
### Train
* Clone this repository somewhere, let's refer to it as $ROOT
```
git clone https://github.com/Ophthalmology-CAD/retro-illumination-images.git
```
* Compile the caffe and pycaffe.
```
cd $ROOT/CS-ResCNN/CS-ResCNN-Code
make all 
make test 
make runtest 
make pycaffe
```
* Download the pre-trained model（https://github.com/KaimingHe/deep-residual-networks#models）
* Run the train.sh in $ROOT/CS-ResCNN/CS-ResCNN-Code/myself/fine-ResNet-50/train.sh to train the model
```
cd $ROOT/CS-ResCNN/CS-ResCNN-Code
sh myself/fine-ResNet-50/train.sh
```

### Test

The test code is in $ROOT/CS-ResCNN/CS-ResCNN-Code/myself/five_fold_cross_twoclass

* Run the five-fold-cross.py to test: in python terminal. 
