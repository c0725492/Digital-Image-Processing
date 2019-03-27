function imgout=expanded(img)
width=5;

alpha= .375; 
windowf = [.25-alpha/2 .25 alpha .25 .25-alpha/2];

kernel = kron(windowf ,windowf')*4;

% expand [a] to [A00 A01;A10 A11] with 4 kernels
A00 = kernel(1:2:width,1:2:width); 
A01 = kernel(1:2:width,2:2:width); 
A10 = kernel(2:2:width,1:2:width); 
A11 = kernel(2:2:width,2:2:width); 


img = im2double(img);
[R C]= size(img(:,:,1));
osize = [R C]*2-1;

[r c d]=size(img);
imgout = zeros(r,c,d);

for p = 1:d
	img1 = img(:,:,p);
	img1ph = padarray(img1,[0 1],'replicate','both'); % horizontally padded
	img1pv = padarray(img1,[1 0],'replicate','both'); % horizontally padded
	
	img00 = imfilter(img1,A00,'replicate','same');
	img01 = conv2(img1pv,A01,'valid'); 
	img10 = conv2(img1ph,A10,'valid');
	img11 = conv2(img1,A11,'valid');
	
	imgout(1:2:osize(1),1:2:osize(2),p) = img00;
	imgout(2:2:osize(1),1:2:osize(2),p) = img10;
	imgout(1:2:osize(1),2:2:osize(2),p) = img01;
	imgout(2:2:osize(1),2:2:osize(2),p) = img11;
end

end