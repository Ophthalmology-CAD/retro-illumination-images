% circlecoords - ����һ����Բ������Ͱ뾶�����Բ�ϵĵ������
% ʹ��: 
% [x,y] = circlecoords(c, r, imgsize,nsides)
%
% ����:
%	c           - ����Բ�����������
%   r           - Բ�İ뾶
%   imgsize     - ���������ͼ������Ĵ�С
%   nsides      - the circle is actually approximated by a polygon, this
%                 argument gives the number of sides used in this approximation. Default
%                 is 600.
%
% Output:
%	x		    - ����Բ�߽���x���������
%   y		    - ����Բ�߽���y���������
%

function [x,y] = circlecoords(c, r, imgsize,nsides)

    
    if nargin == 3
	nsides = 600;
    end
    
    nsides = round(nsides);
    
    a = [0:pi/nsides:2*pi];
    xd = (double(r)*cos(a)+ double(c(1)) );
    yd = (double(r)*sin(a)+ double(c(2)) );
    
    xd = round(xd);
    yd = round(yd);
    
    %��ȥ-VES    
    %��ȥֵ���ں�Ĥͼ��ĵ�
    xd2 = xd;
    coords = find(xd>imgsize(2));
    xd2(coords) = imgsize(2);
    coords = find(xd<=0);
    xd2(coords) = 1;
    
    yd2 = yd;
    coords = find(yd>imgsize(1));
    yd2(coords) = imgsize(1);
    coords = find(yd<=0);
    yd2(coords) = 1;
    
    x = int32(xd2);
    y = int32(yd2);   