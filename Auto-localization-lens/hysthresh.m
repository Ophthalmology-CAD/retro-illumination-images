% HYSTHRESH - 后继阈值处理
% 使用: bw = hysthresh(im, T1, T2)
%
% 参数:
%             im  - 待处理的图像
%             T1  - 高阈值
%             T2  - 低阈值
%
% 输出:
%             bw  - the thresholded image (containing values 0 or 1)
%
% 值高于T1的像素被标记为边缘，之后被连接为边缘。高于T2的也被标记为边缘。
% 假设输入图像为非负的


function bw = hysthresh(im, T1, T2)

if (T2 > T1 | T2 < 0 | T1 < 0)  
  error('T1 must be >= T2 and both must be >= 0 ');
end

[rows, cols] = size(im);    % 预先计算一些值
rc = rows*cols;
rcmr = rc - rows;
rp1 = rows+1;

bw = im(:);                 % 图片存为列向量
pix = find(bw > T1);        % 找值大于 T1的像素点
npix = size(pix,1);         % 所得像素数量

stack = zeros(rows*cols,1); % 创建堆栈数组，使得运算不会溢出

stack(1:npix) = pix;        % 边缘点放入堆栈
stp = npix;                 % 设置堆栈指针
for k = 1:npix
    bw(pix(k)) = -1;        % 标记点为边缘
end


% 预先计算一个数组，任何的值都与其周围八个点的值相关. 注意到图像已经被转换为向量,所以如果将数组重塑为图像，将会是这个样子:
%              n-rows-1   n-1   n+rows-1
%
%               n-rows     n     n+rows
%                     
%              n-rows+1   n+1   n+rows+1

O = [-1, 1, -rows-1, -rows, -rows+1, rows-1, rows, rows+1];

while stp ~= 0            % 堆栈不为空
    v = stack(stp);         % 索引入栈
    stp = stp - 1;
    
    if v > rp1 & v < rcmr   % 防止生成非法索引
			    % 现在看周围的点是否也应入栈以待处理
       index = O+v;	    % 计算像素周围点的索引.	    
       for l = 1:8
	   ind = index(l);
	   if bw(ind) > T2   % 如果值>T2
	       stp = stp+1;  % 入栈
	       stack(stp) = ind;
	       bw(ind) = -1; % 标记为边缘点
	   end
       end
    end
end



bw = (bw == -1);            % 任何非边缘值都归为零 
bw = reshape(bw,rows,cols); % 重塑图形
