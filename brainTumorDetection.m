function varargout = brainTumorDetection(varargin)
% BRAINTUMORDETECTION MATLAB code for brainTumorDetection.fig
%      BRAINTUMORDETECTION, by itself, creates a new BRAINTUMORDETECTION or raises the existing
%      singleton*.
%
%      H = BRAINTUMORDETECTION returns the handle to a new BRAINTUMORDETECTION or the handle to
%      the existing singleton*.
%
%      BRAINTUMORDETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BRAINTUMORDETECTION.M with the given input arguments.
%
%      BRAINTUMORDETECTION('Property','Value',...) creates a new BRAINTUMORDETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before brainTumorDetection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to brainTumorDetection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help brainTumorDetection

% Last Modified by GUIDE v2.5 14-May-2021 20:52:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @brainTumorDetection_OpeningFcn, ...
                   'gui_OutputFcn',  @brainTumorDetection_OutputFcn, ...
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


% --- Executes just before brainTumorDetection is made visible.
function brainTumorDetection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to brainTumorDetection (see VARARGIN)

% Choose default command line output for brainTumorDetection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes brainTumorDetection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = brainTumorDetection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
          
            
            
        






% --- Executes on button press in upload_image.
function upload_image_Callback(hObject, eventdata, handles)
% hObject    handle to upload_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global image im2
[path, user_cancel] = imgetfile();
if user_cancel
    msgbox(sprintf('Invalid Selection'),'Error','Warn');
    return
end
image= imread(path);
% im= im2double(im);
im2= image;
im2=im2double(image);
axes(handles.axes1);
imshow(im2)
title('Patient''s Brain','FontSize',20);






% --- Executes on button press in detect.
function detect_Callback(hObject, eventdata, handles)
% hObject    handle to detect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global image


% % % FILTER
 num_iter = 10;
 delta_t = 1/7;
     kappa = 15;
     option = 2;
     filter_image = anisodiff(image,num_iter,delta_t,kappa,option,handles);
     filter_image = uint8(filter_image);
     
 filter_image=imresize(filter_image,[256,256]);
 if size(filter_image,3)>1
     filter_image=rgb2gray(filter_image);
 end
 axes(handles.axes3);
 imshow(filter_image);
 title('Filtered image','FontSize',20);

c=0;
p=0;

% Thresholding
resized_image=imresize(filter_image,[256,256]);
t0=60;
th=t0+((max(filter_image(:))+min(filter_image(:)))./2);
for i=1:1:size(filter_image)
    for j=1:1:size(filter_image)
        if filter_image(i,j)>th
            p=p+1;
            c=c+1;
            resized_image(i,j)=1;
        else
            resized_image(i,j)=0;
            p=p+1;
        end
    end
end



%Segmentation
label=bwlabel(resized_image);
data=regionprops(label,'Solidity','Area');
density=[data.Solidity];
area=[data.Area];
high_dense_area=density>0.6;
max_area=max(area(high_dense_area));
tumor_label=find(area==max_area);
tumor=ismember(label,tumor_label);



if max_area>100 && c<0.2*p
%     Morphological Operatio
    se=strel('square',5);
    tumor=imdilate(tumor,se);
    
     axes(handles.axes4);
     imshow(tumor);
    title('Tumor','FontSize',20);
    
    [B,L]=bwboundaries(tumor,'noholes');
    axes(handles.axes2);
    imshow(filter_image);
    hold on
    for i=1:length(B)
        plot(B{i}(:,2), B{i}(:,i),'Y','linewidth',2.45);
    end
    title('Detected Tumor','FontSize',20)
    hold off
else
    h=msgbox('No Tumor','status');
    return
end


% --------------------------------------------------------------------
function contact_Callback(hObject, eventdata, handles)
% hObject    handle to contact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function author_Callback(hObject, eventdata, handles)
% hObject    handle to author (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msgbox(sprintf('Name: Aditya Sati\nCourse: Btech(CSE)\nEmail: adityanitinsati49@gmail.com\nUniversity: Graphic Era University'),'Author');

