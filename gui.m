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

% Last Modified by GUIDE v2.5 15-Jun-2019 19:19:15

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
selection = contents{get(hObject,'Value')}; % get name of selected of the tqtl spec in drop-down menu
handles.idx = get(hObject,'Value'); % get index of the selected tqtl
guidata(hObject, handles); % update the gui handles structure

% Description of all corresponding TQTLs
tqtl_descriptions = {'At every time step, a car remains a car across frames';
    'Pedestrians do not move like Superman';
    'phi := [] (p1)';
    ['At every time step, for all the objects (id1) in the frame, ', ...
    'if the object class is cyclist with probability more than 0.7, ', ...
    'then in the next 5 frames the object id1 should still be classified ', ...
    'as a cyclist with probability more than 0.6. '];
    };

% Show the descriptions in GUI in the large text box
set(handles.tqtl_desc, 'String', tqtl_descriptions{get(hObject,'Value')});


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

% Initialize the drop-down selection with all specs
tqtl_options = {'1. Permanence: a car remains a car across frames'; ...
    '2. Kinematics: pedestrians do not move like Superman'; ...
    '3. Correlations: pedestrian next to a bicycle may be a cyclist'; ...
    '4. Temporal Evolution: sizes of bounding boxes change in relation to motion'; ...
    };
set(hObject,'String',tqtl_options);


% --- Executes on button press in browse_file.
function browse_file_Callback(hObject, eventdata, handles)
% hObject    handle to browse_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% file_csv = uigetfile({'*.*','All Files'}, 'Select CSV file containing data stream');
[baseName, folder] = uigetfile({'*.*','All Files'}, 'Select CSV file containing data stream');
file_csv = fullfile(folder, baseName); % full path to the csv file
handles.rawdata = readmatrix(file_csv); % read csv file
handles.filename = file_csv; % name of the csv file
guidata(hObject, handles); % update the GUI data
selected_file_Callback(hObject, eventdata, handles);

function selected_file_Callback(hObject, eventdata, handles)
% hObject    handle to selected_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of selected_file as text
%        str2double(get(hObject,'String')) returns contents of selected_file as a double
myString = handles.filename; % show the chosen file in text box
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

% Index of selected TQTL
% fprintf("Index of selected TQTL: %d\n", handles.idx)

% ==============
% TODO (Anand): 
% Index is available in 'handles.idx'
% Create multiple if conditions to choose spec
Pred(1).str = 'p1';
Pred(1).A = [1];
Pred(1).b = handles.b1;
phi = '[] (p1)';
% ==============

% Raw data from CSV
seqS = handles.rawdata;

% Call the Persephone monitor
[rob, aux] = Persephone.monitor(phi, Pred, seqS);

% Print the results in text box
set(handles.rob_result, 'String', num2str(rob));



function thresh_b1_Callback(hObject, eventdata, handles)
% hObject    handle to thresh_b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh_b1 as text
%        str2double(get(hObject,'String')) returns contents of thresh_b1 as a double
b1 = str2double(get(hObject,'String')); % Value of threshold 1
if isnan(b1)
    b1 = 0.0; % Default 0.0 if not entered in GUI
end
handles.b1 = b1;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function thresh_b1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh_b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.b1 = 0.0; % Default 0.0 if not entered in GUI
guidata(hObject, handles);


function thresh_b2_Callback(hObject, eventdata, handles)
% hObject    handle to thresh_b2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh_b2 as text
%        str2double(get(hObject,'String')) returns contents of thresh_b2 as a double
b2 = str2double(get(hObject,'String')); % Value of threshold 2
if isnan(b2)
    b2 = 0.0; % Default 0.0 if not entered in GUI
end
handles.b2 = b2;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function thresh_b2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh_b2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.b2 = 0.0; % Default 0.0 if not entered in GUI
guidata(hObject, handles);


function thresh_b3_Callback(hObject, eventdata, handles)
% hObject    handle to thresh_b3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh_b3 as text
%        str2double(get(hObject,'String')) returns contents of thresh_b3 as a double
b3 = str2double(get(hObject,'String')); % Value of threshold 3
if isnan(b3) 
    b3 = 0.0; % Default 0.0 if not entered in GUI
end
handles.b3 = b3;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function thresh_b3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh_b3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.b3 = 0; % Default 0.0 if not entered in GUI
guidata(hObject, handles);
