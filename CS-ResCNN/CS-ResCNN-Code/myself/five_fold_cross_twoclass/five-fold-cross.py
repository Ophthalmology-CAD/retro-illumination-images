
__author__ = 'jie'


from get_result_five_fold_cross import *
normal_file='normal'
recurrence_file='recurrence'
surgery_file='surgery'
image='5'
#model=['daxiao-6','daxiao-7','daxiao-8','daxiao-9','daxiao-10','ok-6','ok-7','ok-8','ok-9','ok-10','shenqian-6','shenqian-7','shenqian-8','shenqian-9','shenqian-10','zhongyang-6','zhongyang-7','zhongyang-8','zhongyang-9','zhongyang-10']
#ok_file=['small/6','small/7','small/8','small/9','small/10','ok/6','ok/7','ok/8','ok/9','ok/10','qian/6','qian/7','qian/8','qian/9','qian/10','zhouwei/6','zhouwei/7','zhouwei/8','zhouwei/9','zhouwei/10']
#other_file=['big/6','big/7','big/8','big/9','big/10','other/6','other/7','other/8','other/9','other/10','shen/6','shen/7','shen/8','shen/9','shen/10','zhongyang/6','zhongyang/7','zhongyang/8','zhongyang/9','zhongyang/10']
cnn='fine-ResNet-50'
train_caffemodel=['1','2','4','6','7','8','9','10','11','12','13','14','16','18','20']
#train_caffemodel=['1','12','3','4','5','6','7','8','9','10','11','2','13','14','15','16','17','18','19','20','24','28','34','38','40','42','46','50','100','200']


l=len(model)
for i in range(0,16):
    print i
    get_result_five_fold_cross(normal_file,recurrence_file,surgery_file,image,cnn,train_caffemodel[i])
    #i=i+1
