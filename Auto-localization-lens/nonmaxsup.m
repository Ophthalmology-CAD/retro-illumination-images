% NONMAXSUP
%
% 使用:
%          im = nonmaxsup(inimage, orient, radius);
%
% 通过使用梯度方向图，对一幅图像执行非最大值抑止. 其中梯度方向角度介于 (0-180).
%
% 输入:
%   inimage - 待处理图像
% 
%   orient  - 包含一般特征梯度方向的图像，角度范围正对反时针 0-180度
% 
%   radius  - 对比最大值所用参考距离
%             建议值为 1.2 - 1.5


function im = nonmaxsup(inimage, orient, radius)

if size(inimage) ~= size(orient)
  error('image and orientation image are of different sizes');
end

if radius < 1
  error('radius must be >= 1');
end

[rows,cols] = size(inimage);
im = zeros(rows,cols);        % 预先分配输出图像存储
iradius = ceil(radius);

% 预先计算与每个方向角度的中心象素相关的x和y补偿

angle = [0:180].*pi/180;    % 幅度方向的角度构成数组，步长为一.
xoff = radius*cos(angle);   % 指定来自参考位置上的半径与角度点上的x与y的补偿
yoff = radius*sin(angle);   

hfrac = xoff - floor(xoff); 
vfrac = yoff - floor(yoff); % 与整数部分相关的小数部分补偿

orient = fix(orient)+1;     % 方向从0开始，而数组从索引1开始



for row = (iradius+1):(rows - iradius)
  for col = (iradius+1):(cols - iradius) 

    or = orient(row,col);   % 索引编入预先计算的矩阵

    x = col + xoff(or);     % x，y在关键点的一边的定位
    y = row - yoff(or);

    fx = floor(x);          % 得到围绕x，y的整数象素定位
    cx = ceil(x);
    fy = floor(y);
    cy = ceil(y);
    tl = inimage(fy,fx);    % 左上象素值
    tr = inimage(fy,cx);    % 右上
    bl = inimage(cy,fx);    % 左下
    br = inimage(cy,cx);    % 右下

    upperavg = tl + hfrac(or) * (tr - tl);  % 使用双线性插值估计x，y处的值
    loweravg = bl + hfrac(or) * (br - bl); 
    v1 = upperavg + vfrac(or) * (loweravg - upperavg);

  if inimage(row, col) > v1 % 讨论另外一边的值的情况

    x = col - xoff(or);     % x，y在关键点另外一边的位置
    y = row + yoff(or);

    fx = floor(x);
    cx = ceil(x);
    fy = floor(y);
    cy = ceil(y);
    tl = inimage(fy,fx);    % 左上整数象素处值
    tr = inimage(fy,cx);    % 右上
    bl = inimage(cy,fx);    % 左下
    br = inimage(cy,cx);    % 右下
    upperavg = tl + hfrac(or) * (tr - tl);
    loweravg = bl + hfrac(or) * (br - bl);
    v2 = upperavg + vfrac(or) * (loweravg - upperavg);

    if inimage(row,col) > v2            % 局部最大值
      im(row, col) = inimage(row, col); % 输出图像中记录该值.
    end

   end
  end
end


