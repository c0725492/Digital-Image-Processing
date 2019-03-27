function [RESULT_mean] =wavelet_fun(image1,image2)

r1=image1(:,:,1); %seperate layers of red  image1 
g1=image1(:,:,2); %seperate layers of green image1
b1=image1(:,:,3); %seperate layers of blue image 1

r2=image2(:,:,1);
g2=image2(:,:,2);
b2=image2(:,:,3);

Thres=0.2;

%wavelet fusion 
[ra1 rh1 rv1 rd1]=dwt2(r1,'Haar');
[ga1 gh1 gv1 gd1]=dwt2(g1,'Haar');
[ba1 bh1 bv1 bd1]=dwt2(b1,'Haar');


[ra2 rh2 rv2 rd2]=dwt2(r2,'Haar');
[ga2 gh2 gv2 gd2]=dwt2(g2,'Haar');
[ba2 bh2 bv2 bd2]=dwt2(b2,'Haar');


% wavelet process
RA=ra1+Thres*ra2;
RH=rh1+Thres*rh2;
RV=rv1+Thres*rv2;
RD=rd1+Thres*rd2;

GA=ga1+Thres*ga2;
GH=gh1+Thres*gh2;
GV=gv1+Thres*gv2;
GD=gd1+Thres*gd2;

BA=ba1+Thres*ba2;
BH=bh1+Thres*bh2;
BV=bv1+Thres*bv2;
BD=bd1+Thres*bd2;


RWavout=idwt2(RA,RH,RV,RD,'haar');
GWavout=idwt2(GA,GH,GV,GD,'haar');
BWavout=idwt2(BA,BH,BV,BD,'haar');

RESULT_mean=cat(3,RWavout,GWavout,BWavout);

RESULT_mean=uint8(RESULT_mean);
end