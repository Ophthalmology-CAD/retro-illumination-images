% segmentiris - �ָ��Ĥ�����ͬʱ�������������򣬲��������ͽ�ë�����ڸ�
%
% ʹ�÷�����
% [circleiris, circlepupil, imagewithnoise] = segmentiris(image)
%
% ������
%	eyeimage		- ����ͼ��
%	
% �����
%	circleiris	    - ��Ĥ��Ե������������뾶
%	circlepupil	    - ͫ�ױ�Ե������������뾶 
%	imagewithnoise	- �������������λͼ��
%

function [row, col, r] = segmentiris_2(eyeimage)

% ����ͫ�����Ĥ�뾶��Χ

%CASIA
% lpupilradius = 20;
% upupilradius = 60;
% lirisradius = 80;
% uirisradius = 150;
lirisradius = 20;
uirisradius = 150;


% �������ڼ���hough�任�ķ�������
scaling = 0.4;

reflecthres = 240;

% Ѱ�Һ�Ĥ�빮Ĥ��߽磬����Ĥ��߽�
[row, col, r] = findcircle_tmp(eyeimage, lirisradius, uirisradius, scaling, 2, 0.20, 0.15, 1.00, 0.00);





