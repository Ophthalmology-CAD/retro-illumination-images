% segmentiris - 分割虹膜区域的同时，分离噪声区域，并对眼睑和睫毛进行掩盖
%
% 使用方法：
% [circleiris, circlepupil, imagewithnoise] = segmentiris(image)
%
% 参数：
%	eyeimage		- 输入图像
%	
% 输出：
%	circleiris	    - 虹膜边缘的中心坐标与半径
%	circlepupil	    - 瞳孔边缘的中心坐标与半径 
%	imagewithnoise	- 带噪声的输出定位图像
%

function [row, col, r] = segmentiris_1(eyeimage,colordist)

% 定义瞳孔与虹膜半径范围

%CASIA
% lpupilradius = 20;
% upupilradius = 60;
% lirisradius = 80;
% uirisradius = 150;

% lirisradius = 10;
% uirisradius = 100;
lirisradius = 40;
uirisradius = 400;

colordist_backup = colordist;
% 定义用于加速hough变换的放缩因子
% scaling = 0.4;
scaling = 0.1;

reflecthres = 240;

% tmpcdist = abs((colordist - 0.55).^2);
% colordist(tmpcdist > (0.1).^2) = 0;






% 寻找虹膜与巩膜间边界，即虹膜外边界
[row, col, r] = findcircle(eyeimage, lirisradius, uirisradius, scaling, 2, 0.20, 0.15, 1.00, 0.00);



%把 colordist 在圆外的部分赋值为0，直径向内缩dr个像素
dr = 3;
[ny, nx] = size(colordist);
[xx, yy] = meshgrid(1:nx, 1:ny);
tmp =  (xx - double(col)).^2 + (yy - double(row)).^2 - (double(r)-2).^2;
tmp(tmp>=0) = 0;
tmp(tmp<0) = 1;

colordist = colordist.*tmp;

% tmpcdist = (colordist - 0.55).^2;
% colordist(tmpcdist > (0.1).^2) = 0;

colordist((colordist > 0.9)|(colordist <0.2)) = 0;

se = strel('disk',2); 
colordist = imerode(colordist,se);
colordist = imdilate(colordist,se);

xxxxx = 0;

[row, col, r] = findcircle(colordist, lirisradius, uirisradius, scaling, 2, 0.20, 0.15, 1.00, 0.00);



