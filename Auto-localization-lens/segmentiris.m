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

function [circleiris, circlepupil, imagewithnoise] = segmentiris(eyeimage)

% 定义瞳孔与虹膜半径范围

%CASIA
lpupilradius = 20;
upupilradius = 60;
lirisradius = 80;
uirisradius = 150;


% 定义用于加速hough变换的放缩因子
scaling = 0.4;

reflecthres = 240;

% 寻找虹膜与巩膜间边界，即虹膜外边界
[row, col, r] = findcircle(eyeimage, lirisradius, uirisradius, scaling, 2, 0.20, 0.15, 1.00, 0.00);

circleiris = [row col r];

rowd = double(row);
cold = double(col);
rd = double(r);

irl = round(rowd-rd);
iru = round(rowd+rd);
icl = round(cold-rd);
icu = round(cold+rd);

imgsize = size(eyeimage);

if irl < 1 
    irl = 1;
end

if icl < 1
    icl = 1;
end

if iru > imgsize(1)
    iru = imgsize(1);
end

if icu > imgsize(2)
    icu = imgsize(2);
end

% 在刚才探测得到的虹膜区域中寻找瞳孔
imagepupil = eyeimage( irl:iru,icl:icu);

%寻找瞳孔边界
[rowp, colp, r] = findcircle(imagepupil, lpupilradius, upupilradius ,0.6,2,0.25,0.25,1.00,1.00);

rowp = double(rowp);
colp = double(colp);
r = double(r);

row = double(irl) + rowp;
col = double(icl) + colp;

row = round(row);
col = round(col);

circlepupil = [row col r];

%建立用于记录噪声区域的数组，数组像素具备NaN噪声值
imagewithnoise = double(eyeimage);

%寻找上眼睑
topeyelid = imagepupil(1:(rowp-r),:);
lines = findline(topeyelid);

if size(lines,1) > 0
    [xl yl] = linecoords(lines, size(topeyelid));
    yl = double(yl) + irl-1;
    xl = double(xl) + icl-1;
    
    yla = max(yl);
    
    y2 = 1:yla;
    
    ind3 = sub2ind(size(eyeimage),yl,xl);  %
    imagewithnoise(ind3) = NaN;
    
    imagewithnoise(y2, xl) = NaN;
end

%寻找下眼睑
bottomeyelid = imagepupil((rowp+r):size(imagepupil,1),:);
lines = findline(bottomeyelid);

if size(lines,1) > 0
    
    [xl yl] = linecoords(lines, size(bottomeyelid));
    yl = double(yl)+ irl+rowp+r-2;
    xl = double(xl) + icl-1;
    
    yla = min(yl);
    
    y2 = yla:size(eyeimage,1);
    
    ind4 = sub2ind(size(eyeimage),yl,xl);
    imagewithnoise(ind4) = NaN;
    imagewithnoise(y2, xl) = NaN;
    
end
%叠加睫毛与噪声
ref = eyeimage < 100;
coords = find(ref==1);
imagewithnoise(coords) = NaN;

