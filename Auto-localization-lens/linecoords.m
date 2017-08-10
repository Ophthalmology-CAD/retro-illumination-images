% linecoords - 返回一条直线上的点的坐标
%
% 使用: 
% [x,y] = linecoords(lines, imsize)
%
% 参数:
%	lines       - 包含一条直线的极坐标形式参数的数组
%   imsize      - 图像大小，用以限制坐标范围
%
% 输出:
%	x ,y           -  相关坐标


function [x,y] = linecoords(lines, imsize)

xd = [1:imsize(2)];
yd = (-lines(3) - lines(1)*xd ) / lines(2);

coords = find(yd>imsize(1));
yd(coords) = imsize(1);
coords = find(yd<1);
yd(coords) = 1;

x = int32(xd);
y = int32(yd);   