function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 29-Mar-2016 20:53:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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
end

% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global s;
global fs;
global c;
global d;
contents = get(hObject,'Value');
switch contents
    case 1
        t = 0:1/fs:(length(s) - 1)/fs;
        plot(t, s), axis([0, (length(s) - 1)/fs -0.4 0.5]);
        st=sprintf('Plot of sound signal ');
        title(st);
        xlabel('Time [s]');
        ylabel('Amplitude (normalized)')
    case 2
        M=100;
        N=256;
        % 3 (linear)
        frames = blockFrames(s, fs, M, N);
        t = N / 2;
        tm = length(s) / fs;
        a1=subplot(121);
        imagesc([0 tm], [0 fs/2], abs(frames(1:t, :)).^2), axis xy;
        title('Power Spectrum (M = 100, N = 256)');
        xlabel('Time [s]');
        ylabel('Frequency [Hz]');
        colorbar;
        % 3 (logarithmic)
        a2=subplot(122);
        imagesc([0 tm], [0 fs/2], 20 * log10(abs(frames(1:t, :)).^2)), axis xy;
        title('Logarithmic Power Spectrum (M = 100, N = 256)');
        xlabel('Time [s]');
        ylabel('Frequency [Hz]');
        colorbar;
    case 4
        plot(linspace(0, (fs/2), 129), (melfb(20, 256, fs)));
        title('Mel-Spaced Filterbank');
        xlabel('Frequency [Hz]');
    case 5
        M = 100;
        N = 256;
        n2 = 1 + floor(N / 2);
        frames = blockFrames(s, fs, M, N);
        m = melfb(20, N, fs);
        z = m * abs(frames(1:n2, :)).^2;
        tm = length(s) / fs;
        a1=subplot(121);
        imagesc([0 tm], [0 fs/2], abs(frames(1:n2, :)).^2), axis xy;
        title('Power Spectrum unmodified');
        xlabel('Time [s]');
        ylabel('Frequency [Hz]');
        colorbar;
        a2=subplot(122);
        imagesc([0 tm], [0 20], z), axis xy;
        title('Power Spectrum modified through Mel Cepstrum filter');
        xlabel('Time [s]');
        ylabel('Number of Filter in Filter Bank');
    case 6
        plot(c(5, :), c(6, :), 'or');
        xlabel('5th Dimension');
        ylabel('6th Dimension');
        st=sprintf('Signal');
        legend(st);
        title('2D plot of accoustic vectors');
    case 7
        plot(c(5, :), c(6, :), 'xr')
        hold on
        plot(d(5, :), d(6, :), 'vk')
        xlabel('5th Dimension');
        ylabel('6th Dimension');
        st=sprintf('Speaker');
        st1=sprintf('Codebook');
        legend(st,st1);
        title('2D plot of accoustic vectors');
        hold off
    otherwise
        msgbox('Sorry');
end
end

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
     
end

% --- Executes on button press in OpenModel.
function OpenModel_Callback(hObject, eventdata, handles)
% hObject    handle to OpenModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
global fs;
global nb;
global c;
global d;
global file;
choice=0;
while choice~=3
    choice=menu('Open Model','Browse a sound file','Record a sound','Exit');
    if choice==1
        [FileName,PathName] = uigetfile('*.wav','Select the MATLAB code file');
        file=strcat(PathName,FileName);
         [s fs]=audioread(file);
        p=audioplayer(s,fs);
        play(p);
        c=mfcc(s,fs);
        d=vqlbg(c(:,:),16);
%         t = 0:1/fs:(length(s) - 1)/fs;
%         plot(t, s), axis([0, (length(s) - 1)/fs -0.4 0.5]);
%         st=sprintf('Plot of sound signal ');
%         title(st);
%         xlabel('Time [s]');
%         ylabel('Amplitude (normalized)')
    elseif choice==2
        file=openfig('Record.fig');
        [s fs]=audioread(file);
        p=audioplayer(s,fs);
        play(p);
    end
end
end

% --- Executes on button press in add2db.
function add2db_Callback(hObject, eventdata, handles)
% hObject    handle to add2db (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
            if (exist('sound_database.dat','file')==2)
            load('sound_database.dat','-mat');
            classe = input('Insert a class number (sound ID) that will be used for recognition:');
            if isempty(classe)
                classe = sound_number+1;
                disp( num2str(classe) );
            end
            name=input('Enter the name of the person','s');
%             message=('The following parameters will be used during recording:');
%             disp(message);
%             message=strcat('Sampling frequency',num2str(samplingfrequency));
%             disp(message);
%             message=strcat('Bits per sample',num2str(samplingbits));
%             disp(message);
%             durata = input('Insert the duration of the recording (in seconds):');
%             if isempty(durata)
%                 durata = 3;
%                 disp( num2str(durata) );
%             end
%             micrecorder = audiorecorder(samplingfrequency,samplingbits,1);
%             disp('Now, speak into microphone...');
%             record(micrecorder,durata);
%             
%             while (isrecording(micrecorder)==1)
%                 disp('Recording...');
%                 pause(0.5);
%             end
%             disp('Recording stopped.');
%             y1 = getaudiodata(micrecorder);
%             y = getaudiodata(micrecorder, 'uint8');
%             
%             if size(y,2)==2
%                 y=y(:,1);
%             end
%             y = double(y);
            sound_number = sound_number+1;
            data{sound_number,1} = y;
            data{sound_number,2} = classe;
            data{sound_number,3} = 'Microphone';
            data{sound_number,4} = 'Microphone';
            data{sound_number,5} = name;
            st=strcat('u',num2str(sound_number));
            wavwrite(y1,samplingfrequency,samplingbits,st)
            save('sound_database.dat','data','sound_number','-append');
            msgbox('Sound added to database','Database result','help');
%            disp('Sound added to database');
            
        else
            classe = input('Insert a class number (sound ID) that will be used for recognition:');
            if isempty(classe)
                classe = 1;
                disp( num2str(classe) );
            end
%             durata = input('Insert the duration of the recording (in seconds):');
%             if isempty(durata)
%                 durata = 3;
%                 disp( num2str(durata) );
%             end
%             samplingfrequency = input('Insert the sampling frequency (22050 recommended):');
%             if isempty(samplingfrequency )
%                 samplingfrequency = 22050;
%                 disp( num2str(samplingfrequency) );
%             end
%             samplingbits = input('Insert the number of bits per sample (8 recommended):');
%             if isempty(samplingbits )
%                 samplingbits = 8;
%                 disp( num2str(samplingbits) );
%             end
%             micrecorder = audiorecorder(samplingfrequency,samplingbits,1);
%             disp('Now, speak into microphone...');
%             record(micrecorder,durata);
%             
%             while (isrecording(micrecorder)==1)
%                 disp('Recording...');
%                 pause(0.5);
%             end
%             disp('Recording stopped.');
%             y1 = getaudiodata(micrecorder);
%             y = getaudiodata(micrecorder, 'uint8');
%             
%             if size(y,2)==2
%                 y=y(:,1);
%             end
%             y = double(y);
            sound_number = 1;
            data{sound_number,1} = y;
            data{sound_number,2} = classe;
            data{sound_number,3} = 'Microphone';
            data{sound_number,4} = 'Microphone';
            st=strcat('u',num2str(sound_number));
            wavwrite(y1,samplingfrequency,samplingbits,st);
            save('sound_database.dat','data','sound_number');
            msgbox('Sound added to database','Database result','help');
%            disp('Sound added to database');
        end
end

% --- Executes on button press in info.
function info_Callback(hObject, eventdata, handles)
% hObject    handle to info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
            if (exist('sound_database.dat','file')==2)
            load('sound_database.dat','-mat');
            message=strcat('Database has #',num2str(sound_number),'words:');
            msgbox(message,'Database Information');
%             disp(message);
%             disp(' ');
%             
%             for ii=1:sound_number
%                 message=strcat('Location:',data{ii,3});
%                 disp(message);
%                 message=strcat('File:',data{ii,4});
%                 disp(message);
%                 message=strcat('Sound ID:',num2str(data{ii,2}));
%                 disp(message);
%                 disp('-');
%             end
%             
%             ch32=0;
%             while ch32 ~=2
%                 ch32=menu('Database Information','Database','Exit');
%                 
%                 if ch32==1
%                     st=strcat('Sound Database has : #',num2str(sound_number),'words. Enter a database number : #');
%                     prompt = {st};
%                     dlg_title = 'Database Information';
%                     num_lines = 1;
%                     def = {'1'};
%                     options.Resize='on';
%                     options.WindowStyle='normal';
%                     options.Interpreter='tex';
%                     an = inputdlg(prompt,dlg_title,num_lines,def);
%                     an=cell2mat(an);
%                     a=str2double(an);
%                     
%                     if (isempty(an))
%                         
%                     else
%                         
%                         if (a <= sound_number)
%                             st=strcat('u',num2str(an));
%                             [s fs nb]=wavread(st);
%                             p=audioplayer(s,fs,nb);
%                             play(p);
%                         else
%                             warndlg('Invalid Word ','Warning');
%                         end
%                     end
%                 end
%             end
            
        else
            warndlg('Database is empty.',' Warning ')
        end
end



% --- Executes on button press in deletedb.
function deletedb_Callback(hObject, eventdata, handles)
% hObject    handle to deletedb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (exist('sound_database.dat','file')==2)
            button = questdlg('Do you really want to remove the Database?');
            
            if strcmp(button,'Yes')
                load('sound_database.dat','-mat');
                
                for ii=1:sound_number
                    st=strcat('u',num2str(ii),'.wav');
                    delete(st);
                end
                
                if (exist('v.wav','file')==2)
                    delete('v.wav');
                end
                
                delete('sound_database.dat');
                msgbox('Database was succesfully removed from the current directory.','Database removed','help');
            end
            
        else
            warndlg('Database is empty.',' Warning ')
end
end


% --- Executes on button press in SpeakerRecognition.
function SpeakerRecognition_Callback(hObject, eventdata, handles)
% hObject    handle to SpeakerRecognition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in RecognisedSound.
function RecognisedSound_Callback(hObject, eventdata, handles)
% hObject    handle to RecognisedSound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in RecordedSound.
function RecordedSound_Callback(hObject, eventdata, handles)
% hObject    handle to RecordedSound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in Comparison.
function Comparison_Callback(hObject, eventdata, handles)
% hObject    handle to Comparison (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
end


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
