function varargout = imfus(varargin)
% IMFUS M-file for imfus.fig
%      IMFUS, by itself, creates a new IMFUS or raises the existing
%      singleton*.
%
%      H = IMFUS returns the handle to a new IMFUS or the handle to
%      the existing singleton*.
%
%      IMFUS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMFUS.M with the given input arguments.
%
%      IMFUS('Property','Value',...) creates a new IMFUS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imfus_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imfus_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imfus

% Last Modified by GUIDE v2.5 24-Mar-2015 18:11:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imfus_OpeningFcn, ...
                   'gui_OutputFcn',  @imfus_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before imfus is made visible.
function imfus_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imfus (see VARARGIN)

% Choose default command line output for imfus
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imfus wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imfus_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in image1.
function image1_Callback(hObject, eventdata, handles)
% hObject    handle to image1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im1
[f p]=uigetfile('*.jpg','Select An image To Enhance');
temp=[p f];
im1=imresize(imread(temp),[512 512]);

figure,imshow(im1),title('First image')

axes(handles.axes1)
imshow(im1),title('First image')
im1=double(im1);


% --- Executes on button press in image2.
function image2_Callback(hObject, eventdata, handles)
% hObject    handle to image2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im2
[f p]=uigetfile('*.jpg','Select An image To Enhance');
temp=[p f];
im2=imresize(imread(temp),[512 512]);

figure,imshow(im2),title('Second image')
axes(handles.axes2)
imshow(im2),title('Second image')

im2=double(im2);


% --- Executes on button press in Fusion.
function Fusion_Callback(hObject, eventdata, handles)
% hObject    handle to Fusion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im1 im2 imff a imfw

a=get(handles.popupmenu1,'value');
if a==2

level=4;

for i=1:level
    IM = reduced(im1);
    exim=expanded(IM);
    [r c d]=size(exim);
   
    im1=imresize(im1,[r c ]);
    Id1 = im1 - expanded(IM);
    im1 = IM;
    IM = reduced(im2);
    exim=expanded(IM);
    [r c d]=size(exim);
   
    im2=imresize(im2,[r c ]);
    
    
    Id2 = im2 - expanded(IM);
    im2 = IM;
    dl = abs(Id1)-abs(Id2)>=0;
    Idf{i} = dl.*Id1+(~dl).*Id2;
  
  end

imf=pca_fun(im1,im2);


for i=level:-1:1
    exim=expanded(imf);
    [r c d]=size(expanded(imf));
    idf1=Idf{i};
    exim2=imresize(idf1,[r c]);
    imf = exim2+exim;
   
    
end
imff=imresize(imf,[512 512]);

figure,imshow(uint8(imff)),title('Final Fused Image by Proposed')

axes(handles.axes4)
imshow(uint8(imff)),title('Final Fused Image by Proposed')
imwrite(uint8(imff),'Fused_lap.jpg')

elseif a==1

imfw=wavelet_fun(im1,im2);
           
imwrite(imfw,'fused_wavelet.jpg');


axes(handles.axes3);
imshow(imfw);
title('Fused By wavelet')
figure
imshow(imfw);
title('Fused By wavelet')


end



% --- Executes on button press in Result.
function Result_Callback(hObject, eventdata, handles)
% hObject    handle to Result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a

Original=imresize(imread('Mainoriginal.jpg'),[512 512]);
imff=imread('Fused_lap.jpg');
imfw=imread('fused_wavelet.jpg');



if a==2
fmse=[];
fber=[];
fpsnr=[];
for q=5:50:255
 [FMSE,FBER,FPSNR] = find_ber_psnr_rgb(imff,Original,q);
 fmse=[fmse FMSE];
 fber=[fber FBER];
 fpsnr=[fpsnr FPSNR];
end

figure,
plot(5:50:255,fmse,'*-b')
ylabel('Mean Square Error ')
xlabel('Q Factor')
title('Image Fused by Laplician pyramid and PCA')


figure,
plot(5:50:255,fber,'*-b')
ylabel('Bit Error Rate')
xlabel('Q Factor')
title('Image Fused by Laplician pyramid and PCA')


figure,
plot(5:50:255,fpsnr,'*-b')
ylabel('Peak To Noise Ratio')
xlabel('Q Factor')
title('Image Fused by Laplician pyramid and PCA')

c1=corr2(rgb2gray(Original),rgb2gray(imff))
cor12=['Original and Fused by LP = '   num2str(c1)];
set(handles.text4,'String',cor12)


elseif a==1
wmse=[];
wber=[];
wpsnr=[];
for q=5:50:255
 [FMSE,FBER,FPSNR] = find_ber_psnr_rgb(imff,Original,q);
 wmse=[wmse FMSE];
 wber=[wber FBER];
 wpsnr=[wpsnr FPSNR];
end

figure,
plot(5:50:255,wmse,'*-b')
xlabel('Mean Square Error ')
ylabel('Q Factor')
title('Image Fused by Wavelet')


figure,
plot(5:50:255,wber,'*-b')
xlabel('Bit Error Rate')
ylabel('Q Factor')
title('Image Fused by Wavelet')


figure,
plot(5:50:255,wpsnr,'*-b')
xlabel('Peak To Noise Ratio')
ylabel('Q Factor')
title('Image Fused by Wavelet')
c2=corr2(rgb2gray(Original),rgb2gray(imfw));

cor22=['Original and Fused by DWT = '   num2str(c2)];
set(handles.text5,'String',cor22)

end



% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
close all 
clear all


% --- Executes on button press in Com.
function Com_Callback(hObject, eventdata, handles)
% hObject    handle to Com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

  global im1 im2 

Original=imresize(imread('Mainoriginal.jpg'),[512 512]);
imff=imread('Fused_lap.jpg');
imfw=imread('fused_wavelet.jpg');
% New Parameters
a=mean(mean(imfw/1.5));
WaveMean=max(a(:,:,:));Wb=entropy(imfw/1.5);Wc=std2(imfw/1.5);

a=1;
for q=5:50:255
   [FMSE,FBER,FPSNR] = find_ber_psnr_rgb(imff,Original,q);
   [WMSE,WBER,WPSNR] = find_ber_psnr_rgb(imfw,Original,q);
CMSE(a,:)=[FMSE WMSE];
CBER(a,:)=[FBER WBER];
CPSNR(a,:)=[FPSNR WPSNR];
   a=a+1;
   
end

figure,
plot(5:50:255,CMSE(:,1),'*-b')
hold on
plot(5:50:255,CMSE(:,2),'*-r')
legend('Proposed','Wavelet')
title('Mean Square error')
ylabel('Mse')
xlabel('Q Factor')
figure,
plot(5:50:255,CBER(:,1),'*-b')
hold on
plot(5:50:255,CBER(:,2),'*-r')
legend('Proposed','Wavelet')
title('Bit Error Rate')
ylabel('Ber')
xlabel('Q Factor')
figure,
plot(5:50:255,CPSNR(:,1),'*-b')
hold on
plot(5:50:255,CPSNR(:,2),'*-r')
legend('Proposed','Wavelet')
title('Peak Signal To Noise Ratio')
ylabel('Psnr')
xlabel('Q Factor')

c2=corr2(rgb2gray(Original),rgb2gray(imfw));
c1=corr2(rgb2gray(Original),rgb2gray(imff));
figure 
bar([0 c2 c1 0]);
title('Correlation Of images')
set(gca,'xTicklabel',{'','ORG-Fused DWT','ORG-Fused LP','' })


% New Parameters
a=mean(mean(imff));
ProposedMean=max(a(:,:,:));

figure
bar([0 ProposedMean 0])
title(['Mean Value ' num2str(ProposedMean)])
ylabel('Mean')

b=entropy(imff);
figure
bar([0 b 0])
title(['Entropy ' num2str(b)])
ylabel('Entropy')


c=std2(imff);
figure
bar([0 c 0])
title(['Standard Daviation ' num2str(c)])
ylabel('Standard Daviation')






figure
bar([0 WaveMean 0])
title(['Wavelet  Mean Value ' num2str(WaveMean)])
ylabel('Mean')


figure
bar([0 Wb 0])
title(['Wavelet  Entropy ' num2str(Wb)])
ylabel('Entropy')



figure
bar([0 Wc 0])
title(['Wavelet Standard Daviation ' num2str(Wc)])
ylabel('Standard Daviation')

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
