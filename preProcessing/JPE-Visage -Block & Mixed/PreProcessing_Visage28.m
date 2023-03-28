%{
%%%%Script to preprocess data for Visage experiments (JPE). 
!!!!!!!READ ME!!!!!!!!!!!!!
Input: Raw eeg data *.edf (eeg continuous)
Output: *.erp, *.set files (event related potentials)
 
1) First section of script
Corrects a data acquisition problem related to timing of events 
(creation of multiple set files, change of the Event
information associated with particular electrodes, merging of set files into one set 
file for each participant H1 and H2)

2) ICA procedure to have nice baseline (removal of bad components)
%%%%IMPORTANT Before running ICA channels that were automatically rejected
(in pop_rejchan) need to be excluded see line 220 approx.
%%%%IMPORTANT when 'reject component' window pops up, before rejecting need
to label components manually (PRECAUTION to avoid errors: to make sure
correct .set file loaded, and that correct components were labeled 90%
Muscle or Eye probability, other components are not removed.)

3)Artifact rejection (bad electrode rejection etc)
%%%IMPORTANT Need to remove bad electrodes to run

%%%%IMPORTANT Run section per section (in Editor > Run and Advance NOT 'RUN')
%%%%SCRIPT NEEDS TO BE IN 'OUTPUT' folder in current folder. Run script from cd!!. 

-21/06/22
%}

%% Output files named with "0.1 Hz"
clear all
%close all
clc

%open eeglab
eeglab

% search for .edf file in the current directory
searchFilter = '*.EDF';
currentDirectory = pwd;
asciiFileDirectory = fullfile( currentDirectory);
addpath( asciiFileDirectory );
searchString = [asciiFileDirectory, '/', searchFilter];
filesList = dir(searchString);

% Boucle pour lire tout .edf
for i=1:length(filesList)
    file_name(i)= fopen(filesList(i).name);% lire le fichier
end

i=1:length(file_name);

for j=1:8
    
    name_temp = filesList(i).name;
    
    %initializing variable
    events=[];
    %specify channels
    channels=((j-1)*9+1):j*9;
    
    %start processing data
    %open EDF file in eeglab
    EEGSET=pop_biosig(filesList(i).name, 'channels', channels);
    
    % Choose the correct event list
    if name_temp(3) == 'B'% if EDF files have a B in 3rd position in name
        events =[currentDirectory '/EVENTLIST-Block.txt'];
    elseif name_temp(3) == 'M'
        events =[currentDirectory '/EVENTLIST-Mixed2020.txt'];
    end
    
    % load event info
    EEGSET  = pop_editeventlist( EEGSET , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List',...
        events, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Warning', 'on' );
    
    % filter data
    EEGSET = pop_eegfiltnew( EEGSET, [], 40, [], false, [], 0);
    EEGSET = pop_eegfiltnew( EEGSET, 0.1, [], [], false, [], 0);
    
    % create epochs
    EEGSET = pop_epochbin( EEGSET , [-204.0  1200.0],  [ -204 -4]);
    
    EEG=EEGSET;
    % adjust channel labels
    if (j==1 || j==5)
        placingelectrode = {'ch1 = ch1 label X', 'ch2 = ch2 label Y', 'ch3 = ch3 label Fp2',  'ch4 = ch4 label Fp1',  'ch5 = ch5 label F8',  'ch6 = ch6 label F7', 'ch7 = ch7 label Fz',  'ch8 = ch8 label Cz'};
    elseif (j==2 || j==6)
        placingelectrode = {'ch1 = ch1 label Pz',  'ch2 = ch2 label P4',  'ch3 = ch3 label P3',  'ch4 = ch4 label T6', 'ch5 = ch5 label T5',  'ch6 = ch6 label T4',  'ch7 = ch7 label T3', 'ch8 = ch8 label A1A2'};
    elseif (j==3 || j==7)
        placingelectrode = {'ch1 = ch1 label F4', 'ch2 = ch2 label F3',  'ch3 = ch3 label Ft8',  'ch4 = ch4 label Ft7',  'ch5 = ch5 label Fc4',  'ch6 = ch6 label Fc3',  'ch7 = ch7 label Fcz', 'ch8 = ch8 label C4'};
    elseif (j==4 || j==8)
        placingelectrode = {'ch1 = ch1 label C3', 'ch2 = ch2 label Tp8',  'ch3 = ch3 label Tp7',  'ch4 = ch4 label Cp4',  'ch5 = ch5 label Cp3', 'ch6 = ch6 label O2',  'ch7 = ch7 label O1', 'ch8 = ch8 label Nez'};
    end
    
    EEG = pop_eegchanoperator(EEG, placingelectrode);
    
    % save
    nameerp = [name_temp(1:2) 'b' int2str(j)];
    EEG = pop_saveset( EEG, ['0.1HZ_' nameerp '.'], [currentDirectory '/output']);
    
end

% merge datasets
name_temp = filesList(i).name;
nameH1 = ['0.1HZ_' name_temp(1:2) 'H1.'];
nameH2 = ['0.1HZ_' name_temp(1:2) 'H2.'];
merge_2020_labeled(['0.1HZ_' name_temp(1:2) 'b1.set'], ['0.1HZ_' name_temp(1:2) 'b2.set'], ['0.1HZ_' name_temp(1:2) 'b3.set'], ['0.1HZ_' name_temp(1:2) 'b4.set'], nameH1);
merge_2020_labeled(['0.1HZ_' name_temp(1:2) 'b5.set'], ['0.1HZ_' name_temp(1:2) 'b6.set'], ['0.1HZ_' name_temp(1:2) 'b7.set'], ['0.1HZ_' name_temp(1:2) 'b8.set'], nameH2);

%%
% Output files: 1 Hz
clear all
close all
clc

%open eeglab
eeglab

% search for .edf file in the current directory
searchFilter = '*.EDF';
currentDirectory = pwd;
asciiFileDirectory = fullfile( currentDirectory);
addpath( asciiFileDirectory );
searchString = [asciiFileDirectory, '/', searchFilter];
filesList = dir(searchString);

% Boucle pour lire tout .edf
for i=1:length(filesList)
    file_name(i)= fopen(filesList(i).name);% lire le fichier
end

i=1:length(file_name);

for j=1:8
    
    name_temp = filesList(i).name;
    
    %initializing variable
    events=[];
    %specify channels
    channels=((j-1)*9+1):j*9;
    
    %start processing data
    %open EDF file in eeglab
   
    EEGSET=pop_biosig(filesList(i).name, 'channels', channels);
    
    % choose the correct event list
    if name_temp(3) == 'B'
        events =[currentDirectory '/EVENTLIST-Block.txt'];
    elseif name_temp(3) == 'M'
        events =[currentDirectory '/EVENTLIST-Mixed2020.txt'];
    end
    
    % load event info
    EEGSET  = pop_editeventlist( EEGSET , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List',...
        events, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Warning', 'on' );
    
    % filter data
    EEGSET = pop_eegfiltnew( EEGSET, 1, [], [], false, [], 0);
    
    % create epochs
    EEGSET = pop_epochbin( EEGSET , [-204.0  1200.0],  [ -204 -4]);
    
    EEG=EEGSET;
    % adjust channel labels
    if (j==1 || j==5)
        placingelectrode = {'ch1 = ch1 label X', 'ch2 = ch2 label Y', 'ch3 = ch3 label Fp2',  'ch4 = ch4 label Fp1',  'ch5 = ch5 label F8',  'ch6 = ch6 label F7', 'ch7 = ch7 label Fz',  'ch8 = ch8 label Cz'};
    elseif (j==2 || j==6)
        placingelectrode = {'ch1 = ch1 label Pz',  'ch2 = ch2 label P4',  'ch3 = ch3 label P3',  'ch4 = ch4 label T6', 'ch5 = ch5 label T5',  'ch6 = ch6 label T4',  'ch7 = ch7 label T3', 'ch8 = ch8 label A1A2'};
    elseif (j==3 || j==7)
        placingelectrode = {'ch1 = ch1 label F4', 'ch2 = ch2 label F3',  'ch3 = ch3 label Ft8',  'ch4 = ch4 label Ft7',  'ch5 = ch5 label Fc4',  'ch6 = ch6 label Fc3',  'ch7 = ch7 label Fcz', 'ch8 = ch8 label C4'};
    elseif (j==4 || j==8)
        placingelectrode = {'ch1 = ch1 label C3', 'ch2 = ch2 label Tp8',  'ch3 = ch3 label Tp7',  'ch4 = ch4 label Cp4',  'ch5 = ch5 label Cp3', 'ch6 = ch6 label O2',  'ch7 = ch7 label O1', 'ch8 = ch8 label Nez'};
    end
    
    EEG = pop_eegchanoperator(EEG, placingelectrode);
    
    % save
    nameerp = [name_temp(1:2) 'b' int2str(j)];
    EEG = pop_saveset( EEG, ['1HZ_' nameerp], [currentDirectory '/output']);
    
end

% merge datasets
name_temp = filesList(i).name;
nameH1 = ['1HZ_' name_temp(1:2) 'H1'];
nameH2 = ['1HZ_' name_temp(1:2) 'H2'];
merge_2020_labeled(['1HZ_' name_temp(1:2) 'b1.set'], ['1HZ_' name_temp(1:2) 'b2.set'], ['1HZ_' name_temp(1:2) 'b3.set'], ['1HZ_' name_temp(1:2) 'b4.set'], nameH1);
merge_2020_labeled(['1HZ_' name_temp(1:2) 'b5.set'], ['1HZ_' name_temp(1:2) 'b6.set'], ['1HZ_' name_temp(1:2) 'b7.set'], ['1HZ_' name_temp(1:2) 'b8.set'], nameH2);

% remove channels
placingelectrode = {'nch1 = ch3 label Fp2',  'nch2 = ch4 label Fp1',  'nch3 = ch5 label F8',  'nch4 = ch6 label F7', 'nch5 = ch7 label Fz',  'nch6 = ch8 label Cz', ...
            'nch7 = ch9 label Pz',  'nch8 = ch10 label P4',  'nch9 = ch11 label P3',  'nch10 = ch12 label T6', 'nch11 = ch13 label T5',  'nch12 = ch14 label T4',  'nch13 = ch15 label T3', ...
            'nch14 = ch17 label F4',  'nch15 = ch18 label F3', 'nch16 = ch19 label Ft8',  'nch17 = ch20 label Ft7',  'nch18 = ch21 label Fc4',  'nch19 = ch22 label Fc3',  'nch20 = ch23 label Fcz',  'nch21 = ch24 label C4',...
            'nch22 = ch25 label C3',  'nch23 = ch26 label Tp8',  'nch24 = ch27 label Tp7',  'nch25 = ch28 label Cp4',  'nch26 = ch29 label Cp3', 'nch27 = ch30 label O2',  'nch28 = ch31 label O1'};

for j=1:2
    
    EEG = pop_loadset('filename',['1HZ_' name_temp(1:2) 'H' int2str(j) '.set'],'filepath',[pwd '\output']);
    EEG = pop_eegchanoperator(EEG, placingelectrode);
    EEG = pop_saveset( EEG, ['ChRm_1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], [pwd '/output']);

    EEG = pop_loadset('filename',['0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'],'filepath',[pwd '\output']);
    EEG = pop_eegchanoperator(EEG, placingelectrode);
    EEG = pop_saveset( EEG, ['ChRm_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], [pwd '/output']);

end

%%
% Participant H1

j=1;

%initializing variable
nameerp = [name_temp(1:2) 'H' int2str(j) '.erp'];
electrodes=[];

% load 1HZ dataset
EEG = pop_loadset('filename',['ChRm_1HZ_' name_temp(1:2) 'H' int2str(j) '.set'],'filepath',[pwd '\output']);
EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Standard-10-20-Cap81-28.ced']);

% automatic channel rejection
pop_rejchan(EEG)
% EEG = pop_rejchan(EEG, 'elec',[1:32] ,'threshold',5,'norm','on','measure','prob');
fprintf('If *bad* channels exist, remove them from brackets in pop_runica (L230)')

%% run ICA
% MANUAL MANIPULATION Chanind remove *bad* electrode from brackets to run ica e.g.[1:23 25:28] %24
EEG = pop_runica(EEG, 'icatype', 'runica', 'chanind', [1:28], 'extended',1);  
EEG = pop_saveset( EEG, 'filename',['ICA_1HZ_' name_temp(1:2) 'H' int2str(j) '.set'],'filepath',[pwd '\output']);

TMP.icawinv = EEG.icawinv;
TMP.icasphere = EEG.icasphere;
TMP.icaweights = EEG.icaweights;
TMP.icachansind = EEG.icachansind;
% apply to epoched dataset
clear EEG;

%CHANGE NAME
EEG = pop_loadset('filename', ['ChRm_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath', [pwd '\output']);
EEG.icawinv = TMP.icawinv;
EEG.icasphere = TMP.icasphere;
EEG.icaweights = TMP.icaweights;
EEG.icachansind = TMP.icachansind;
clear TMP;
EEG = pop_saveset(EEG, 'filename',['ICA_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath', [pwd '\output']);

 fprintf('For next section: Be careful when removing components. Potential manual check')
%% 
%%%%IMPORTANT when 'reject component' window pops up, before rejecting need
%to label components manually (PRECAUTION to avoid errors: to make sure
%correct .set file loaded, and that correct components were labeled 90%
%Muscle or Eye probability, other components are not removed.)

EEG = pop_loadset('filename', ['ICA_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath', [pwd '\output']);
EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Standard-10-20-Cap81-28.ced']);
EEG=iclabel(EEG);
noisethreshold = [0 0;0.9 1; 0.9 1; 0 0; 0 0; 0 0; 0 0]; %
EEG = pop_icflag(EEG, noisethreshold);
% remove bad component(s)
EEG = pop_subcomp( EEG );
% save
EEG = pop_saveset(EEG, 'filename',['ICs_ICA_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath', [pwd '\output']);

% check bad channels again
pop_rejchan(EEG)

fprintf('For next section: Remove *bad electrodes from brackets')
%% artifact detection

%%%!! exclude *bad* electrodes, comment which electrode(s) and restore after
% participant is done
frontals = [1:4];
if name_temp(3)=='B' && j==1
    electrodes=[5:15 16:17 18:28];%change electrode here or in frontals;
elseif name_temp(3)=='M' 
    electrodes=[5 6 7:13 14:16 18:21 23:28];
end

%peak to peak
EEG  = pop_artextval( EEG , 'Channel', electrodes, 'Flag',  1, 'Threshold', [ -75 75], 'Twindow',[ -204 1200] );

%peak to peak for fp1 fp2 f7 f8
EEG  = pop_artextval( EEG , 'Channel', frontals, 'Flag',  1, 'Threshold', [ -100 100], 'Twindow',[ -204 1200] );

%flat line
EEG  = pop_artflatline( EEG , 'Channel', electrodes, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow', [ -204 1200] );
EEG  = pop_artflatline( EEG , 'Channel', frontals, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow', [ -204 1200] );

EEG = pop_saveset( EEG, ['AR' nameerp] ,[pwd '\output']);

%% compute erp
ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' );

% placing the electrodes for plot
%ERP = pop_erpchanoperator( ERP, placingelectrode );

% load channel location information
ERP = pop_erpchanedit( ERP, [currentDirectory '/Standard-10-20-Cap81-28.ced']);

% Save the erp
ERP = pop_savemyerp(ERP, 'erpname', nameerp, 'filename', nameerp, 'filepath', [pwd '\output'], 'Warning', 'on');

ERP = pop_summary_AR_erp_detection(ERP, [currentDirectory '\output\' nameerp(1:end-4) '.txt']);

ERP = pop_summary_rejectfields(EEG);

%% Same for participant H2

j=2;

%initializing variable
nameerp = [name_temp(1:2) 'H' int2str(j) '.erp'];
electrodes=[];

% load 1HZ dataset
EEG = pop_loadset('filename',['ChRm_1HZ_' name_temp(1:2) 'H' int2str(j) '.set'],'filepath',[pwd '\output']);
EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Standard-10-20-Cap81-28.ced']);

% automatic channel rejection
pop_rejchan(EEG)
EEG = pop_rejchan(EEG, 'elec',[1:32] ,'threshold',5,'norm','on','measure','prob');
%not working: parameters to select test 'probability'
fprintf('If *bad* channels exist, remove them from brackets in pop_runica')

%% run ICA
% MANUAL MANIPULATION Chanind remove *bad* electrode from brackets to run ica e.g.[1:23 25:28] %24
EEG = pop_runica(EEG, 'icatype', 'runica', 'chanind', [1:28], 'extended',1); %  change chanind to reject bad electrode if needed
EEG = pop_saveset( EEG, 'filename',['ICA_1HZ_' name_temp(1:2) 'H' int2str(j) '.set'],'filepath',[pwd '\output']);

TMP.icawinv = EEG.icawinv;
TMP.icasphere = EEG.icasphere;
TMP.icaweights = EEG.icaweights;
TMP.icachansind = EEG.icachansind;
% apply to epoched dataset
clear EEG;

%CHANGE NAME
EEG = pop_loadset('filename', ['ChRm_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath', [pwd '\output']);
EEG.icawinv = TMP.icawinv;
EEG.icasphere = TMP.icasphere;
EEG.icaweights = TMP.icaweights;
EEG.icachansind = TMP.icachansind;
clear TMP;
EEG = pop_saveset(EEG, 'filename',['ICA_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath', [pwd '\output']);

fprintf('For next section: Be careful when removing components. Potential manual check')
%%
%%%%IMPORTANT when 'reject component' window pops up, before rejecting need
%to label components manually (PRECAUTION to avoid errors: to make sure
%correct .set file loaded, and that correct components were labeled 90%
%Muscle or Eye probability, other components are not removed.)

EEG = pop_loadset('filename', ['ICA_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath', [pwd '\output']);
EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Standard-10-20-Cap81-28.ced']);%verify chanlocs is correct
EEG=iclabel(EEG);
noisethreshold = [0 0;0.9 1; 0.9 1; 0 0; 0 0; 0 0; 0 0]; % might need to be changed
EEG = pop_icflag(EEG, noisethreshold);
% remove bad component(s)
EEG = pop_subcomp( EEG );
% save
EEG = pop_saveset(EEG, 'filename',['ICs_ICA_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath', [pwd '\output']);

% check bad channels again
pop_rejchan(EEG)

 fprintf('For next section: Remove *bad electrodes from brackets')
%% artifact detection
%exclude *bad* electrodes, comment which electrode(s) and restore after
% participant done
frontals = [1:4];%
if name_temp(3)=='B' && j==1
    electrodes=[5 6 7:21 22:28]%%change electrode here or in frontals;
elseif name_temp(3)=='M'
    electrodes=[5 6 7:13 14:21 22:28];
end

%peak to peak
EEG  = pop_artextval( EEG , 'Channel', electrodes, 'Flag',  1, 'Threshold', [ -75 75], 'Twindow',[ -204 1200] );

%peak to peak for fp1 fp2 f7 f8
EEG  = pop_artextval( EEG , 'Channel', frontals, 'Flag',  1, 'Threshold', [ -100 100], 'Twindow',[ -204 1200] );

%flat line
EEG  = pop_artflatline( EEG , 'Channel', electrodes, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow', [ -204 1200] );
EEG  = pop_artflatline( EEG , 'Channel', frontals, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow', [ -204 1200] );

EEG = pop_saveset( EEG, ['AR' nameerp] ,[pwd '\output']);

%% compute erp
ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' );

% placing the electrodes for plot
%ERP = pop_erpchanoperator( ERP, placingelectrode );

% load channel location information
ERP = pop_erpchanedit( ERP, [currentDirectory '/Standard-10-20-Cap81-28.ced']);

% Save the erp
ERP = pop_savemyerp(ERP, 'erpname', nameerp, 'filename', nameerp, 'filepath', [pwd '\output'], 'Warning', 'on');

ERP = pop_summary_AR_erp_detection(ERP, [currentDirectory '\output\' nameerp(1:end-4) '.txt']);

ERP = pop_summary_rejectfields(EEG);


fprintf('DONE, GREAT JOB!! NOW SAVE YOUR LAST CREATED .SET files, .Erp & TXT. Recalculate elec if needed.'); 
%Good job!! %Now save the last SET files, ERP files. 
%Recalculate electrodes in EEGlab if needed and plot ERPs. 
