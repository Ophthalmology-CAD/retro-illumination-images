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

function [row, col, r] = segmentiris_2(eyeimage)

% 定义瞳孔与虹膜半径范围

%CASIA
% lpupilradius = 20;
% upupilradius = 60;
% lirisradius = 80;
% uirisradius = 150;
lirisradius = 20;
uirisradius = 150;


% 定义用于加速hough变换的放缩因子
scaling = 0.4;

reflecthres = 240;

% 寻找虹膜与巩膜间边界，即虹膜外边界
[row, col, r] = findcircle_tmp(eyeimage, lirisradius, uirisradius, scaling, 2, 0.20, 0.15, 1.00, 0.00);





