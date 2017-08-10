function auto_localization_lens()

% version: 1.2  liulin  20170221
%addpath('./Segmentation');
version='version: 1.2   20170221';
disp(version);
filelist = dir('/home/long/cost/static/Predict/*.jpg');
outW = 128;% 

for index=1:length(filelist)
    index
     inputfname = filelist(index).name;
    disp(inputfname);
    eyeimage = (imread(['/home/long/cost/static/Predict/' inputfname])); 
    I=imresize(eyeimage,[212*4 320*4]);
    imwrite(I,strcat('/home/long/cost/static/Predict','/',inputfname))
    eyeimage = (imread(['/home/long/cost/static/Predict/' inputfname])); 
    
    
    eyeimage_backup = eyeimage;

    % ����ǲ�ɫͼ��ת�� ��ת���ɻҶ�ͼ�񣬣��ȼٶ���ͼ����ûҶ���Ϣ�Ϳ��Էָ
    if length(size(eyeimage))==3
%         eyeimage=eyeimage(:,:,1);%rgb2gray(eyeimage);
        eyeimage = rgb2hsv(eyeimage);
        colordist = eyeimage(:,:,1);
        eyeimage=eyeimage(:,:,2);
    end
    eyeimage = double(eyeimage);

    % ��Ϊ���˵��۾���Ƭ���񶼾�����ɢͫ��������ʱ������ֺ�Ĥ�ı߽��ͫ�׵ı߽�
    [row col r] = segmentiris_1(eyeimage,colordist);

    
    



    rowd = double(row);
    cold = double(col);
    rd = double(r);

    irl = round(rowd-rd);
    iru = round(rowd+rd);
    icl = round(cold-rd);
    icu = round(cold+rd);

    imgsize = size(eyeimage);
    
    % �ж� �Ƿ񴥼��߽�
    tmpedg = [0 0,0 0];% �� �� �� �� ����
    if irl < 1 
        irl = 1;
        tmpedg(1) = 1;
    end

    if icl < 1
        icl = 1;
        tmpedg(3) = 1;
    end

    if iru > imgsize(1)
        iru = imgsize(1);
        tmpedg(2) = 1;
    end

    if icu > imgsize(2)
        icu = imgsize(2);
        tmpedg(4) = 1;
    end

    % ����м�����������
    circleiris = [row col r];
    [x,y] = circlecoords([circleiris(2),circleiris(1)],circleiris(3),size(eyeimage));
    ind2 = sub2ind(size(eyeimage),double(y),double(x)); 
    ttt = eyeimage_backup;
    ttt(ind2) = 255;
    %imwrite(uint8(ttt),['./tmp/' inputfname(1:end-4) '.jpg'])
    
    
    % ��ȡͼ���е���Ч����
    imagepupil = eyeimage_backup( irl:iru,icl:icu,:);
%     tmp = zeros(rd*2+1,rd*2+1,3);
    
    % ��ͼ����䵽 ��2*r+1)*(2*r+1) ��С�ķ����У� ����������0�� ��ʱ���ѧϰ�������Ҫ��������Ҫ�����ò������NaN
    if tmpedg(1) == 1 % ��      
        [ty,tx,tz]=size(imagepupil);
        tmp1 = [zeros(rd-rowd+1,tx); imagepupil(:,:,1)];
        tmp2 = [zeros(rd-rowd+1,tx); imagepupil(:,:,2)];
        tmp3 = [zeros(rd-rowd+1,tx); imagepupil(:,:,3)];
        tmpc = zeros([size(tmp1) 3]);
        tmpc(:,:,1) = tmp1;
        tmpc(:,:,2) = tmp2;
        tmpc(:,:,3) = tmp3;
        imagepupil = tmpc;
    end
     if tmpedg(2) == 1 % ��  
        [ty,tx,tz]=size(imagepupil);
        tmp1 = [imagepupil(:,:,1); zeros(rowd+rd-imgsize(1),tx)];
        tmp2 = [imagepupil(:,:,2); zeros(rowd+rd-imgsize(1),tx)];
        tmp3 = [imagepupil(:,:,3); zeros(rowd+rd-imgsize(1),tx)];
        tmpc = zeros([size(tmp1) 3]);
        tmpc(:,:,1) = tmp1;
        tmpc(:,:,2) = tmp2;
        tmpc(:,:,3) = tmp3;
        imagepupil = tmpc;
     end
    
    if tmpedg(3) == 1 % ��
        [ty,tx,tz]=size(imagepupil);
        tmp1 = [zeros(ty,rd-cold+1),imagepupil(:,:,1)];
        tmp2 = [zeros(ty,rd-cold+1),imagepupil(:,:,2)];
        tmp3 = [zeros(ty,rd-cold+1),imagepupil(:,:,3)];
        tmpc = zeros([size(tmp1) 3]);
        tmpc(:,:,1) = tmp1;
        tmpc(:,:,2) = tmp2;
        tmpc(:,:,3) = tmp3;
        imagepupil = tmpc;
    end
     if tmpedg(4) == 1 % ��
        [ty,tx,tz]=size(imagepupil);
        tmp1 = [imagepupil(:,:,1),zeros(ty,cold+rd-imgsize(2)),];
        tmp2 = [imagepupil(:,:,2),zeros(ty,cold+rd-imgsize(2)),];
        tmp3 = [imagepupil(:,:,3),zeros(ty,cold+rd-imgsize(2)),];
        tmpc = zeros([size(tmp1) 3]);
        tmpc(:,:,1) = tmp1;
        tmpc(:,:,2) = tmp2;
        tmpc(:,:,3) = tmp3;
        imagepupil = tmpc;
     end
     imagepupil = imresize(imagepupil,[outW,outW]);
	 delete(['/home/long/cost/static/Predict/' inputfname]);
     imwrite(uint8(imagepupil),['/home/long/cost/static/Predict/' inputfname]);

    
    
end% for







