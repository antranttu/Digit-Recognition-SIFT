

function varargout = gui_test2(varargin)
global vl_path;
vl_path = 'C:\Program Files\MATLAB\vlfeat\toolbox\vl_setup';
% GUI_TEST2 MATLAB code for gui_test2.fig
%      GUI_TEST2, by itself, creates a new GUI_TEST2 or raises the existing
%      singleton*.
%
%      H = GUI_TEST2 returns the handle to a new GUI_TEST2 or the handle to
%      the existing singleton*.
%
%      GUI_TEST2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TEST2.M with the given input arguments.
%
%      GUI_TEST2('Property','Value',...) creates a new GUI_TEST2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_test2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_test2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_test2

% Last Modified by GUIDE v2.5 26-Nov-2018 20:05:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_test2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_test2_OutputFcn, ...
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


% --- Executes just before gui_test2 is made visible.
function gui_test2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_test2 (see VARARGIN)

% Choose default command line output for gui_test2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_test2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_test2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xps;
xps = [];
global yps;
yps = [];
global clc_flag;
clc_flag = 1;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xps;
global yps;
%x hengzhou y zongzhou, different from images
xlimt = 300;
ylimt = 400;
test_img = zeros(ylimt,xlimt);
xps = round(xps);
yps = round(yps);
xps(xps>xlimt) = xlimt; xps(xps<0) = 0;
yps(yps>ylimt) = ylimt; yps(yps<0) = 0;
pxl_inx = sub2ind([ylimt,xlimt],400-yps,xps);
test_img(pxl_inx) = 1;
global pnsh
result = recog(test_img,pnsh);
msgbox(num2str(result));
xps = []; yps = [];

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
clear;
global train_imgs
global tr_frames
global tr_descr
global vl_path
global pnsh
pnsh = ones(10,1);
run(vl_path);
% % train_imgs = generate_tr_set();

% [tr_frames, tr_descr] = train_features(train_imgs);
load('descriptors');
load('features');
tr_frames = features_all;
tr_descr = descriptors_all;
for i = 1:10
    a = 0;
    for j = 1:size(tr_frames,2)
        a = a+size(tr_frames{i,j},2);
    end
    pnsh(i)=a/10;
end
cla reset;

axis on;
% hold on;
global xps;
xps = [];
global yps;
yps = [];
global clc_flag;
clc_flag = 0;
while 1

    title('Input Canvas');
    xlim([25 275]);
    ylim([25 375]);
    hFH = imfreehand();
    xy = hFH.getPosition;
    delete(hFH);
    xCoordinates = xy(:, 1);
    yCoordinates = xy(:, 2);
    numberOfKnots = length(xCoordinates);
    samplingRateIncrease = 10;
    newXSamplePoints = linspace(1, numberOfKnots, numberOfKnots * samplingRateIncrease);
    yy = [0, xCoordinates', 0; 1, yCoordinates', 1];
    pp = spline(1:numberOfKnots, yy); % Get interpolant
    smoothedY = ppval(pp, newXSamplePoints); % Get smoothed y values in the "gaps".
% smoothedY is a 2D array with the x coordinates in the top row and the y coordinates in the bottom row.
    it_xps = smoothedY(1, :);
    it_yps = smoothedY(2, :);
    xps = [xps;it_xps'];
    yps = [yps;it_yps'];
    scatter(xps, yps,'b.');
    
end

% Hint: place code in OpeningFcn to populate axes1
