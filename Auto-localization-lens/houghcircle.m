% houghcircle - ʹ��Hough�任Ѱ��ͼ���е�Բ
%
% ʹ�ã� 
% h = houghcircle(edgeim, rmin, rmax)
%
% ����:
%	edgeim      - ������ı߽�ͼ
%   rmin, rmax  - Ѱ�ҷ�Χ�������С�뾶
% ���:
%	h           - �任���
%

function h = houghcircle(edgeim, rmin, rmax)

[rows,cols] = size(edgeim);
nradii = rmax-rmin+1;
h = zeros(rows,cols,nradii);

[y,x] = find(edgeim~=0);

%����ÿ���㣬������ͬ�뾶��Բ
for index=1:size(y)
    
    cx = x(index);
    cy = y(index);
    
    for n=1:nradii
        
        h(:,:,n) = addcircle(h(:,:,n),[cx,cy],n+rmin);
        
    end
    
end
