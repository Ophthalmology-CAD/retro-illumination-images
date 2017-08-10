% ADJGAMMA - ����gamma�Աȶ�
%
%ʹ�ã� function g = adjgamma(im, g)
%
% Arguments:
%            im     - �������ͼ��
%            g      - gammaֵ.
%                     0-1ʱ��ǿ��������Աȶȣ�����1ʱ��ǿ�ڰ�����Աȶ� 


function newim = adjgamma(im, g)

    if g <= 0
	error('Gamma value must be > 0');
    end

    if isa(im,'uint8');
	newim = double(im);
    else 
	newim = im;
    end
    	
    % �������ط�Χ0-1֮��
    newim = newim-min(min(newim));
    newim = newim./max(max(newim));
    
    newim =  newim.^(1/g);   % ʹ��gamma����


