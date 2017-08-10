% NONMAXSUP
%
% ʹ��:
%          im = nonmaxsup(inimage, orient, radius);
%
% ͨ��ʹ���ݶȷ���ͼ����һ��ͼ��ִ�з����ֵ��ֹ. �����ݶȷ���ǶȽ��� (0-180).
%
% ����:
%   inimage - ������ͼ��
% 
%   orient  - ����һ�������ݶȷ����ͼ�񣬽Ƕȷ�Χ���Է�ʱ�� 0-180��
% 
%   radius  - �Ա����ֵ���òο�����
%             ����ֵΪ 1.2 - 1.5


function im = nonmaxsup(inimage, orient, radius)

if size(inimage) ~= size(orient)
  error('image and orientation image are of different sizes');
end

if radius < 1
  error('radius must be >= 1');
end

[rows,cols] = size(inimage);
im = zeros(rows,cols);        % Ԥ�ȷ������ͼ��洢
iradius = ceil(radius);

% Ԥ�ȼ�����ÿ������Ƕȵ�����������ص�x��y����

angle = [0:180].*pi/180;    % ���ȷ���ĽǶȹ������飬����Ϊһ.
xoff = radius*cos(angle);   % ָ�����Բο�λ���ϵİ뾶��Ƕȵ��ϵ�x��y�Ĳ���
yoff = radius*sin(angle);   

hfrac = xoff - floor(xoff); 
vfrac = yoff - floor(yoff); % ������������ص�С�����ֲ���

orient = fix(orient)+1;     % �����0��ʼ�������������1��ʼ



for row = (iradius+1):(rows - iradius)
  for col = (iradius+1):(cols - iradius) 

    or = orient(row,col);   % ��������Ԥ�ȼ���ľ���

    x = col + xoff(or);     % x��y�ڹؼ����һ�ߵĶ�λ
    y = row - yoff(or);

    fx = floor(x);          % �õ�Χ��x��y���������ض�λ
    cx = ceil(x);
    fy = floor(y);
    cy = ceil(y);
    tl = inimage(fy,fx);    % ��������ֵ
    tr = inimage(fy,cx);    % ����
    bl = inimage(cy,fx);    % ����
    br = inimage(cy,cx);    % ����

    upperavg = tl + hfrac(or) * (tr - tl);  % ʹ��˫���Բ�ֵ����x��y����ֵ
    loweravg = bl + hfrac(or) * (br - bl); 
    v1 = upperavg + vfrac(or) * (loweravg - upperavg);

  if inimage(row, col) > v1 % ��������һ�ߵ�ֵ�����

    x = col - xoff(or);     % x��y�ڹؼ�������һ�ߵ�λ��
    y = row + yoff(or);

    fx = floor(x);
    cx = ceil(x);
    fy = floor(y);
    cy = ceil(y);
    tl = inimage(fy,fx);    % �����������ش�ֵ
    tr = inimage(fy,cx);    % ����
    bl = inimage(cy,fx);    % ����
    br = inimage(cy,cx);    % ����
    upperavg = tl + hfrac(or) * (tr - tl);
    loweravg = bl + hfrac(or) * (br - bl);
    v2 = upperavg + vfrac(or) * (loweravg - upperavg);

    if inimage(row,col) > v2            % �ֲ����ֵ
      im(row, col) = inimage(row, col); % ���ͼ���м�¼��ֵ.
    end

   end
  end
end


