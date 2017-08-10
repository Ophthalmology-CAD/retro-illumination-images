% CANNY - Canny��Ե���
% ����ʹ������ Fleck ������޸� (IEEE PAMI No. 3, Vol. 14. March 1992. pp 337-345)
%
% ʹ�ã�
%      [gradient or] = canny(im, sigma)
%
% Arguments:   im       - Ҫ�����ͼ��
%              sigma    - ��˹ƽ���˲����ı�׼ƫ�ƣ�����ֵΪ1
%		       scaling  - ��С����ͼ��ı�������
%		       vert     - ��ֱ�ݶȷ���
%		       horz     - ˮƽ�ݶȷ���
%
% Returns:     gradient - �߽���ǿͼ�� (�ݶȷ�ֵ)
%              or       - �ݶȷ��� (0-180,˳/��ʱ��)
%
% ͬʱ�μ�:  NONMAXSUP, HYSTHRESH

function [gradient, or] = canny(im, sigma, scaling, vert, horz)

xscaling = vert;
yscaling = horz;

hsize = [6*sigma+1, 6*sigma+1];   % �˲�����ʽ����

gaussian = fspecial('gaussian',hsize,sigma);
im = filter2(gaussian,im);        % ƽ��ͼ��

im = imresize(im, scaling);       % ������С 

[rows, cols] = size(im);

h =  [  im(:,2:cols)  zeros(rows,1) ] - [  zeros(rows,1)  im(:,1:cols-1)  ];
v =  [  im(2:rows,:); zeros(1,cols) ] - [  zeros(1,cols); im(1:rows-1,:)  ];
d1 = [  im(2:rows,2:cols) zeros(rows-1,1); zeros(1,cols) ] - ...
                               [ zeros(1,cols); zeros(rows-1,1) im(1:rows-1,1:cols-1)  ];
d2 = [  zeros(1,cols); im(1:rows-1,2:cols) zeros(rows-1,1);  ] - ...
                               [ zeros(rows-1,1) im(2:rows,1:cols-1); zeros(1,cols)   ];

X = ( h + (d1 + d2)/2.0 ) * xscaling;
Y = ( v + (d1 - d2)/2.0 ) * yscaling;

gradient = sqrt(X.*X + Y.*Y); % �ݶȷ�ֵ������Ϊ����ʽ����

or = atan2(-Y, X);            % ����-pi��+pi
neg = or<0;                   % ���Ȼ�Ϊ0-pi
or = or.*~neg + (or+pi).*neg; 
or = or*180/pi;               % ת��Ϊ�Ƕ�
