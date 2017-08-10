% CANNY - Canny边缘检测
% 代码使用了由 Fleck 提出的修改 (IEEE PAMI No. 3, Vol. 14. March 1992. pp 337-345)
%
% 使用：
%      [gradient or] = canny(im, sigma)
%
% Arguments:   im       - 要处理的图像
%              sigma    - 高斯平滑滤波器的标准偏移，典型值为1
%		       scaling  - 缩小输入图像的比例因子
%		       vert     - 竖直梯度分量
%		       horz     - 水平梯度分量
%
% Returns:     gradient - 边界增强图像 (梯度幅值)
%              or       - 梯度方向 (0-180,顺/逆时针)
%
% 同时参见:  NONMAXSUP, HYSTHRESH

function [gradient, or] = canny(im, sigma, scaling, vert, horz)

xscaling = vert;
yscaling = horz;

hsize = [6*sigma+1, 6*sigma+1];   % 滤波器格式定义

gaussian = fspecial('gaussian',hsize,sigma);
im = filter2(gaussian,im);        % 平滑图像

im = imresize(im, scaling);       % 比例缩小 

[rows, cols] = size(im);

h =  [  im(:,2:cols)  zeros(rows,1) ] - [  zeros(rows,1)  im(:,1:cols-1)  ];
v =  [  im(2:rows,:); zeros(1,cols) ] - [  zeros(1,cols); im(1:rows-1,:)  ];
d1 = [  im(2:rows,2:cols) zeros(rows-1,1); zeros(1,cols) ] - ...
                               [ zeros(1,cols); zeros(rows-1,1) im(1:rows-1,1:cols-1)  ];
d2 = [  zeros(1,cols); im(1:rows-1,2:cols) zeros(rows-1,1);  ] - ...
                               [ zeros(rows-1,1) im(2:rows,1:cols-1); zeros(1,cols)   ];

X = ( h + (d1 + d2)/2.0 ) * xscaling;
Y = ( v + (d1 - d2)/2.0 ) * yscaling;

gradient = sqrt(X.*X + Y.*Y); % 梯度幅值，上面为按公式计算

or = atan2(-Y, X);            % 弧度-pi到+pi
neg = or<0;                   % 弧度画为0-pi
or = or.*~neg + (or+pi).*neg; 
or = or*180/pi;               % 转换为角度
