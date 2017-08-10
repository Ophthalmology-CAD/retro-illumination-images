% findcircle - 使用Hough变换和Canny算子边缘检测返回图像中一个圆的坐标值来建立边界图
% 使用 ：
% [row, col, r] = findcircle(image,lradius,uradius,scaling, sigma, hithres, lowthres, vert, horz)
%
% 参数：
%	image		    - 将要检测圆的图像
%	lradius		    - 检测最小半径
%	uradius		    - 检测最大半径
%	scaling		    - 加速Hough变换的放缩因子
%	sigma		    - 用于创建边界图的高斯平滑因子
%	hithres		    - 用于创建边界图的阈值
%	lowthres	    - 用于连接边缘的阈值
%	vert		    - 竖直边界比重(0-1)
%	horz		    - 水平边界比重(0-1)
%	
% Output:
%	circleiris	    - 虹膜边界的中心坐标与半径
%	circlepupil	    - 瞳孔边界的中心坐标与半径
%	imagewithnoise	- 带噪声的输出定位图像


function [row, col, r] = findcircle(image,lradius,uradius,scaling, sigma, hithres, lowthres, vert, horz)

lradsc = round(lradius*scaling);
uradsc = round(uradius*scaling);
rd = round(uradius*scaling - lradius*scaling);

% 生成边界图
[I2 or] = canny(image, sigma, scaling, vert, horz);
I3 = adjgamma(I2, 1.9);
I4 = nonmaxsup(I3, or, 1.5);
edgeimage = hysthresh(I4, hithres, lowthres);

edgeimage = edge(imresize(image,scaling),'sobel');

% tmpimg = imresize(colordist,scaling).*double(edgeimage);
% 
% edgeimage = edge(edgeimage,'sobel');

% 执行检测圆的hough变换
h = houghcircle(edgeimage, lradsc, uradsc);

maxtotal = -1000000;

% 寻找Hough空间中的最大值，即圆的参数

[YN, XN] = size(edgeimage);
stepX = 2/(XN-1);
stepY = 2/(YN-1);
[XX, YY]=meshgrid(-1:stepX:1,-1:stepY:1);

KK = sqrt(XX.*XX+YY.*YY);

for i=1:rd
    
%     layer = h(:,:,i);
    
    layer = h(:,:,i);% - 30*KK;
%     keral = ones(11);
%     layer = filter2(keral,layer);
    
    [maxlayer] = max(max(layer));
    
    
    if maxlayer > maxtotal
        
        maxtotal = maxlayer;
        
        
        r = int32((lradsc+i) / scaling);
        
        [row,col] = ( find(layer == maxlayer) );
        
        
        row = int32(row(1) / scaling); % 返回空间中第一个值即最大值
        col = int32(col(1) / scaling);    
        
    end 
%     figure,imshow(layer,[])
end






