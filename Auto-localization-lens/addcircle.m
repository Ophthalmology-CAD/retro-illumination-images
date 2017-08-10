% ADDCIRCLE    ����Բ���ߵļ�Ȩ��
%
% ʹ��:  h = addcircle(h, c, radius, weight)
% 
% ����:
%            h      - 2ά�ۼ�����
%            c      - Բ�ĵ�����[x,y]
%            radius - Բ�İ뾶
%            weight - ��Ȩ����
%
% ����ֵ:   h - ���µ��ۼ�����

function h = addcircle(h, c, radius, weight)

    [hr, hc] = size(h);
    
    if nargin == 3
	weight = 1;
    end
    
    % c ��뾶����Ϊ����
    if any(c-fix(c))
	error('Circle centre must be in integer coordinates');
    end
    
    if radius-fix(radius)
	error('Radius must be an integer');
    end
    
    x = 0:fix(radius/sqrt(2));
    costheta = sqrt(1 - (x.^2 / radius^2));
    y = round(radius*costheta);
    
    % ����ԳƵ�����
    
    px = c(2) + [x  y  y  x -x -y -y -x];
    py = c(1) + [y  x -x -y -y -x  x  y];

    % ��ֹ���ֱ߽���ĵ�
    validx = px>=1 & px<=hr;
    validy = py>=1 & py<=hc;    
    valid = find(validx & validy);

    px = px(valid);
    py = py(valid);
    
    ind = px+(py-1)*hr;
    h(ind) = h(ind) + weight;
