% ADJGAMMA - 调整gamma对比度
%
%使用： function g = adjgamma(im, g)
%
% Arguments:
%            im     - 待处理的图像
%            g      - gamma值.
%                     0-1时增强明亮区域对比度，大于1时增强黑暗区域对比度 


function newim = adjgamma(im, g)

    if g <= 0
	error('Gamma value must be > 0');
    end

    if isa(im,'uint8');
	newim = double(im);
    else 
	newim = im;
    end
    	
    % 限制象素范围0-1之间
    newim = newim-min(min(newim));
    newim = newim./max(max(newim));
    
    newim =  newim.^(1/g);   % 使用gamma函数


