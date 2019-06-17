function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 14-Jun-2019 11:08:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_OpeningFcn, ...
    'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in select_sanity.
function select_sanity_Callback(hObject, eventdata, handles)
% hObject    handle to select_sanity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns select_sanity contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_sanity
contents = cellstr(get(hObject,'String'));
selection = contents{get(hObject,'Value')};
handles.select_opt = get(hObject,'Value');

opt1_desc = [...
    'At every time step, a cyclist remains a cyclist across frames. ', newline, ...
    'Here, if the object tracking algorithm detects a cyclist with probability greater than "a", ', ...
    'the algorithm continues detecting the cyclist with probability "b" for the next 5 frames. ', newline, newline,...
    'phi := []( @ Var_x ( car_a -> []( ({ Var_x>=0 }/\{ Var_x<=5 } ) -> car_b ) ) ).', newline, ...
    'The two configurable parameters "a" and "b" (denoted by "car_a" and "car_b" above), can be set below (first two boxes).'];

opt2_desc = [...
    'Pedestrians should not move like Superman.', newline,...
    'Here, we check if a pedestrian is detected and if so, the pedestrian must also be detected in the next 10 frames. ', newline, ...
    'phi := []( @ Var_x ( pedestrian_a -> []( ({ Var_x>=0 }/\{ Var_x<=10 } ) -> pedestrian_b ) ) ).', newline, ...
    ];

opt3_desc = [...
    'Here, we check that if a cyclist is was previously classified correctly '...,
    'with high probability "a", they may be detected as a pedestrian due to '...,
    'vision constraints. Thus, we check if the probability remains greater '...,
    'than "b" for the next 6 frames for both, cyclist and pedestrian (if the boxes are close together).', newline, newline,...
    'phi := []( @ Var_x ( cycle_a -> [](  ( { Var_x>=0 }/\{ Var_x<=5 } ) -> ( cycle_b \/ ( close_c /\ ped_b ) ) )  ) )', newline, ...
    'Configure "a" and "b" using the first two boxes below. The third box helps specify a distance threshold between the boxes.'
    ];

opt4_desc = [...
    'At every time step, for all the objects (id1) in the frame, ', ...
    'if the object class is cyclist with probability more than 0.7, ', ...
    'then in the next 5 frames the object id1 should still be classified ', ...
    'as a cyclist with probability more than 0.6. '
    ];

tqtl_descriptions = {opt1_desc; opt2_desc; opt3_desc; opt4_desc;};
set(handles.tqtl_desc, 'String', tqtl_descriptions{get(hObject,'Value')});
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function select_sanity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_sanity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
tqtl_options = {'Permanence: a car remains a car across frames.'; ...
    'Kinematics: pedestrians do not move like Superman.';
    'Misclassification: A cyclist may be detected as a pedestrian.'; ...
    'Temporal Evolution: sizes of bounding boxes change in relation to motion.'; ... % TODO(andy): I am not sure how to do this
    };
set(hObject,'String',tqtl_options);


% --- Executes on button press in browse_file.
function browse_file_Callback(hObject, eventdata, handles)
% hObject    handle to browse_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% file_csv = uigetfile({'*.*','All Files'}, 'Select CSV file containing data stream');
[baseName, folder] = uigetfile({'*.*','All Files'}, 'Select CSV file containing data stream');
file_csv = fullfile(folder, baseName);
% handles.rawdata = readmatrix(file_csv);
% CSV Data provided is of the form:
% Frame Index, xmin, ymin, xmax, ymax, label, probability
fid = fopen(file_csv);
handles.rawdata = textscan(fid, '%d %f %f %f %f %s %f', 'Delimiter', ',');
fclose(fid);
handles.filename = file_csv;
guidata(hObject, handles);
selected_file_Callback(hObject, eventdata, handles);

function selected_file_Callback(hObject, eventdata, handles)
% hObject    handle to selected_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of selected_file as text
%        str2double(get(hObject,'String')) returns contents of selected_file as a double
myString = handles.filename;
set(handles.selected_text, 'String', myString);

% --- Executes during object creation, after setting all properties.
function selected_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selected_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Preprocessing
% CSV Data provided is of the form:
% Frame Index, xmin, ymin, xmax, ymax, label, probability
%
% This must first be made into a form that can easily be used to setup the
% predicates and the Monitor.

% First get the raw data
rawdata = handles.rawdata;
% [rawdata_rows, ~] = size(rawdata);
[rawdata_rows, ~] = size(rawdata{1});

% Let's convert the data from a matrix to an array of structs
data_array = {};
prev_idx = 0;
boxes = [];
max_idx = 0;
for i = 1:rawdata_rows
%     idx = rawdata(i,1);
    idx = rawdata{1}(i);
    if prev_idx ~= idx
        data_array{prev_idx+1,1}=boxes;
        boxes = [];
        prev_idx = idx;
    end
%     data_xmin = rawdata(i,2);
%     data_ymin = rawdata(i,3);
%     data_xmax = rawdata(i,4);
%     data_ymax = rawdata(i,5);
%     label_type = rawdata(i, 6);
%     probability = rawdata(i, 7);
    data_xmin = rawdata{2}(i);
    data_ymin = rawdata{3}(i);
    data_xmax = rawdata{4}(i);
    data_ymax = rawdata{5}(i);
    label_type = rawdata{6}(i)
    probability = rawdata{7}(i);
    data_center = [(data_xmin+data_xmax)/2,(data_ymin+data_ymax)/2];
    
    box=struct(...
        'label', label_type,...
        'probability',probability,...
        'left',data_xmin,'top',data_ymin,'right',data_xmax,'bottom',data_ymax,...
        'center',data_center);
    boxes = [boxes; box];
    max_idx = idx-1;
end
% Now, data_array contains a cell aray indexing frame to all the boxes
% (structs) detected in that frame.
celldisp(data_array);
%% Specific Processing of data and dispatching to Persephone.monitor
selected_opt = handles.select_opt;
switch selected_opt
    case 1
        disp('Case 1');
        [phi, Pred, seqS] = tqtl_opt1(data_array, max_idx, handles);
        [rob, aux] = Persephone.monitor(phi, Pred, seqS);
        set(handles.rob_result, 'String', num2str(rob));
    case 2
        disp('Case 2');
        [phi, Pred, seqS] = tqtl_opt2(data_array, max_idx, handles);
        [rob, aux] = Persephone.monitor(phi, Pred, seqS);
        set(handles.rob_result, 'String', num2str(rob));
    case 3
        disp('Case 3');
        % Cyclist-pedestrian misclassification
        phi ='[]( @ Var_x ( cycle_a -> [](  ( { Var_x>=0 }/\{ Var_x<=5 } ) -> ( cycle_b \/ ( close /\ ped_b ) ) )  ) )';
        
        Pred(1).str = 'cycl07';
        Pred(1).A = [-1 0];
        Pred(1).b = [-handles.thresh_b1];
        Pred(2).str = 'cycl06';
        Pred(2).A = [-1 0];
        Pred(2).b = [-handles.thresh_b2];
        Pred(3).str = 'data';
        Pred(3).A = [0 -1;0 1];
        Pred(3).b = [0;40];
        Pred(4).str = 'ped06';
        Pred(4).A = [0 -1];
        Pred(4).b = [-0.6];
    case 4
        % TODO(andy): Temporal Evolution
end

%% -- Individual dispatches.
function [phi, Pred, SeqS] = tqtl_opt1(data_array, max_idx, handles)
% Setup opt1
% Car permanance: Rip off from DATE2019 Cyclist demo
probs = [];
for i= 1: max_idx
    p=0;
    sz=size(data_array{i});
    for j=1:sz(1)
        data_array{i}(j).label
        if strcmp(data_array{i}(j).label,'car')
            p=data_array{i}(j).probability;
        end
    end
    probs =[probs;p];
end
% phi = '[]( @ Var_x ( car_a -> []( ({ Var_x>=0 }/\{ Var_x<=5 } ) -> car_b ) ) )';
phi = '[]( car_a -> ([]_[0,5] car_b) )';
Pred(1).str = 'car_a';
Pred(1).A = [-1 0];
Pred(1).b = [-1*handles.thresh_b1];
Pred(2).str = 'car_b';
Pred(2).A = [-1 0];
Pred(2).b = [-1*handles.thresh_b2];
SeqS=[probs, probs];

function [phi, Pred, SeqS] = tqtl_opt2(data_array, max_idx, handles)
% Setup opt2
% Pedestrians do not move like Superman
probs =[];
for i= 1: max_idx
    p=0;
    sz=size(data_array{i});
    for j=1:sz(1)
        if strcmp(data_array{i}(j).label,'cyclist')
            p=data_array{i}(j).probability;
        end
    end
    probs =[probs;p];
end
% phi = 'phi := []( @ Var_x ( pedestrian_a -> []( ({ Var_x>=0 }/\{ Var_x<=10 } ) -> pedestrian_b ) ) )';
phi = '[]( pedestrian_a -> ([]_[0,10] pedestrian_b) )';
Pred(1).str = 'pedestrian_a';
Pred(1).A = [-1 0];
Pred(1).b = [-1*handles.thresh_b1];
Pred(2).str = 'pedestrian_b';
Pred(2).A = [-1 0];
Pred(2).b = [-1*handles.thresh_b2];
SeqS=[probs, probs];

function [phi, Pred, SeqS] = tqtl_opt3(data_array, max_idx, handles)
% Setup opt3
% Misclassification: Ripoff of DATE2019 demo
disp('lol');
cyclistProb=[];
cyclistCenter=[];
for i= 1: max_idx
    p=0;
    c=[0,0];
    sz=size(data_array{i});
    for j=1:sz(1)
        if strcmp(data_array{i}(j).label,'cyclist')
            p=data_array{i}(j).probability;
            c=data_array{i}(j).center;
        end
    end
    cyclistProb=[cyclistProb;p];
    cyclistCenter=[cyclistCenter;c];
end
pedestrianProb=[];
pedestrianCenter=[];
for i=start + 1: indexEnd + 1
    p=0;
    c=[0,0];
    sz=size(Squeeze_Det{i});
    for j=1:sz(1)
        if strcmp(Squeeze_Det{i}(j).label,'pedestrian')
            p=Squeeze_Det{i}(j).probability;
            c=Squeeze_Det{i}(j).center;
        end
    end
    pedestrianProb=[pedestrianProb;p];
    pedestrianCenter=[pedestrianCenter;c];
end
dist=zeros( indexEnd + 1, indexEnd + 1);
for i=start + 1: indexEnd + 1
    if cyclistProb(i)==0
        dist(i,:)=-500000;
        continue;
    end
    for j=start + 1: indexEnd + 1
        if pedestrianProb(j)==0
            dist(i,j)=-500000;
        else
            dist(i,j)=pdist([cyclistCenter(i,:);pedestrianCenter(j,:)],'euclidean');
        end
    end
end

% phi='[]( @ Var_x ( cycle_a -> [](  ( { Var_x>=0 }/\{ Var_x<=5 } ) -> ( cycle_b \/ ( close_c /\ ped_b ) ) )  ) )';
phi='[]( cycle_a -> []_[0,5]( cycle_b \/ ( close_c /\ ped_b ) ) )';
Pred(1).str = 'cycle_a';
Pred(1).A = [-1 0];
Pred(1).b = [-1*handles.thresh_b1];
Pred(2).str = 'cycle_b';
Pred(2).A = [-1 0];
Pred(2).b = [-1*handles.thresh_b2];
Pred(3).str = 'close_c';
Pred(3).A = [0 -1;0 1];
Pred(3).b = [0;handles.thresh_b3];
Pred(4).str = 'ped_b';
Pred(4).A = [0 -1];
Pred(4).b = [-1*handles.thresh_b2];
SeqS=[cyclistProb,pedestrianProb];


function thresh_b1_Callback(hObject, eventdata, handles)
% hObject    handle to thresh_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh_b as text
%        str2double(get(hObject,'String')) returns contents of thresh_b as a double
handles.thresh_b1 = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function thresh_b1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function thresh_b2_Callback(hObject, eventdata, handles)
% hObject    handle to thresh_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh_b as text
%        str2double(get(hObject,'String')) returns contents of thresh_b as a double
handles.thresh_b2 = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function thresh_b2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function thresh_b3_Callback(hObject, eventdata, handles)
% hObject    handle to thresh_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh_b as text
%        str2double(get(hObject,'String')) returns contents of thresh_b as a double
handles.thresh_b3 = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function thresh_b3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
