% HYSTHRESH - �����ֵ����
% ʹ��: bw = hysthresh(im, T1, T2)
%
% ����:
%             im  - �������ͼ��
%             T1  - ����ֵ
%             T2  - ����ֵ
%
% ���:
%             bw  - the thresholded image (containing values 0 or 1)
%
% ֵ����T1�����ر����Ϊ��Ե��֮������Ϊ��Ե������T2��Ҳ�����Ϊ��Ե��
% ��������ͼ��Ϊ�Ǹ���


function bw = hysthresh(im, T1, T2)

if (T2 > T1 | T2 < 0 | T1 < 0)  
  error('T1 must be >= T2 and both must be >= 0 ');
end

[rows, cols] = size(im);    % Ԥ�ȼ���һЩֵ
rc = rows*cols;
rcmr = rc - rows;
rp1 = rows+1;

bw = im(:);                 % ͼƬ��Ϊ������
pix = find(bw > T1);        % ��ֵ���� T1�����ص�
npix = size(pix,1);         % ������������

stack = zeros(rows*cols,1); % ������ջ���飬ʹ�����㲻�����

stack(1:npix) = pix;        % ��Ե������ջ
stp = npix;                 % ���ö�ջָ��
for k = 1:npix
    bw(pix(k)) = -1;        % ��ǵ�Ϊ��Ե
end


% Ԥ�ȼ���һ�����飬�κε�ֵ��������Χ�˸����ֵ���. ע�⵽ͼ���Ѿ���ת��Ϊ����,�����������������Ϊͼ�񣬽������������:
%              n-rows-1   n-1   n+rows-1
%
%               n-rows     n     n+rows
%                     
%              n-rows+1   n+1   n+rows+1

O = [-1, 1, -rows-1, -rows, -rows+1, rows-1, rows, rows+1];

while stp ~= 0            % ��ջ��Ϊ��
    v = stack(stp);         % ������ջ
    stp = stp - 1;
    
    if v > rp1 & v < rcmr   % ��ֹ���ɷǷ�����
			    % ���ڿ���Χ�ĵ��Ƿ�ҲӦ��ջ�Դ�����
       index = O+v;	    % ����������Χ�������.	    
       for l = 1:8
	   ind = index(l);
	   if bw(ind) > T2   % ���ֵ>T2
	       stp = stp+1;  % ��ջ
	       stack(stp) = ind;
	       bw(ind) = -1; % ���Ϊ��Ե��
	   end
       end
    end
end



bw = (bw == -1);            % �κηǱ�Եֵ����Ϊ�� 
bw = reshape(bw,rows,cols); % ����ͼ��
