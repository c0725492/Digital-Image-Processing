function [MSE, BER, PSNR ] = find_ber_psnr_rgb(img_new,img_org,q)
%UNTITLED2 Summary of this function goes here

img_new=double(img_new);
img_org=double(img_org);
[nRow nColumn]= size(img_new);
Q=q;
img_new_ch1=img_new(:,:,1);
img_org_ch1= img_org(:,:,1);

img_new_ch2=img_new(:,:,2);
img_org_ch2= img_org(:,:,2);

img_new_ch3=img_new(:,:,3);
img_org_ch3= img_org(:,:,3);

img_def_ch3=img_new_ch3-img_org_ch3;
img_def_ch2=img_new_ch2-img_org_ch2;
img_def_ch1=img_new_ch1-img_org_ch1;


MSE_ch3 = sum(sum(img_def_ch3 .^2))/nRow / nColumn;
MSE_ch2 = sum(sum(img_def_ch2 .^2))/nRow / nColumn;
MSE_ch1 = sum(sum(img_def_ch1 .^2))/nRow / nColumn;

MSE=(MSE_ch1+MSE_ch2+MSE_ch3)/3;

PSNR= 10*log10(Q*Q/MSE);

BER= 1/PSNR;
end