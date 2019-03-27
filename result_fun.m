function [x_red y_green z_blue] =result_fun(fused_image)
red=fused_image(:,:,1);
green=fused_image(:,:,2);
blue=fused_image(:,:,3);
%calculation of mean value of red colour
x1=mean(red);
x_red=mean(x1);

%calculation of mean value of green colour
y1=mean(green);
y_green=mean(y1);

%calculation of mean value of blue colour
z1=mean(blue);
z_blue=mean(z1);

end