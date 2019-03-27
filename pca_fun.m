function [imf] =pca_fun(imge1,imge2)
[r c d]=size(imge1);
image1=imge1;
image2=double(imresize(imge2,[r c]));
r1=image1(:,:,1);
g1=image1(:,:,2);
b1=image1(:,:,3);
r2=image2(:,:,1);
g2=image2(:,:,2);
b2=image2(:,:,3);

C = cov([r1(:) r2(:)]);     % convolution of red contents of both images
[V, D] = eig(C);           % calculation of eigen values and eigen vectors 
if D(1,1) >= D(2,2)         % when eigen values of image 1 is more than or equal to 2
  pca = V(:,1)./sum(V(:,1));   % took properties of first one
else  
  pca = V(:,2)./sum(V(:,2));     % otherwise took properties of second one
end

% fusion
Rimf = pca(1)*r1 + pca(2)*r2;

C1 = cov([g1(:) g2(:)]);
[V1, D1] = eig(C1);
if D1(1,1) >= D1(2,2)
  pca1 = V1(:,1)./sum(V1(:,1));
else  
  pca1 = V1(:,2)./sum(V1(:,2));
end

% fusion
Gimf1 = pca1(1)*g1 + pca1(2)*g2;

C2 = cov([b1(:) b2(:)]);
[V2, D2] = eig(C2);
if D2(1,1) >= D2(2,2)
  pca2 = V2(:,1)./sum(V2(:,1));
else  
  pca2 = V2(:,2)./sum(V2(:,2));
end

% fusion
Bimf2 = pca2(1)*b1 + pca2(2)*b2;

final=cat(3,Rimf,Gimf1,Bimf2);
imf=final;
end