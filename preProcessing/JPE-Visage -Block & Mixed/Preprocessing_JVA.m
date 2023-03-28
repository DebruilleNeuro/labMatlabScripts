%This script is the first step in processing EEG data. The root files are
%our raw EEG continuous data acquired during a testing session. The output
%will be continuous data in MATLAB files (set files) and epoched data
%(erp sets). Artifact rejection is performed on the data. This script does not filter
%the data and ICA is not applied.
%
%Files that need to be in your current directory for this script to work: one or multiple EDF files (raw EEG continuous), channel
%location file, Eventlist file. 

clear all %clear all variables in workspace
%close all %close open windows
clc %clear command window

%addpath= add path in quotes to MATLAB path, genpath=add all the directories below the directory (eeglab subfolders) 
addpath(genpath('/Users\jeula\Documents\current subjects\eeglab2021.1')) 

%open eeglab, the plugin we use to process EEG data
eeglab

%First, we will load the files of interest (EDF files present in directory)
%To do so we will indicate to MATLAB to search for files with the extension
%'.EDF' in the current path

searchFilter = '*.EDF'; %creates a character array with the value '.EDF'. EDF is the file type characterizing raw continuous data. 
%searchFilter = '*.set';

%adds current folder to Matlab path
currentDirectory = pwd; %pwd = function that returns the current folder

% Computes the directory in which we will look for files to convert.
EDFFileDirectory = fullfile( currentDirectory);

addpath( EDFFileDirectory );

% We will only search for EDF files in the designated directory
searchString = [EDFFileDirectory, '/', searchFilter];

% We obtain a list of all files in a directory (each row in structure array
% points to one of the files in directory)
filesList = dir(searchString);

% Loop to read all files
for i=1:length(filesList) %from 1 to N (N being the number of files in filesList). e.g if length(filesList)=3, loop will execute 3 times and each time extract the name of each file and store it in 'file_name'
    file_name(i)= fopen(filesList(i).name);% name extracted from filesList and stored in file_name
end

%Loop that will iterate through all the EDF files (using their names stored
%in file_name. The loop will repeat until all the files are processed
for i=1:length(file_name) %from 1 to N (N = number of names (or rows) in array file_name)
    
    %initializing variables, "=[]" creates empty array in workspace,
    %first iterance of variable = defines the variable and allows us to use
    %it later in the script
    ERPSET =[]; %will store output erp files created
    ERP=[]; %will store current erp file
    nameset=[]; %will be used to name set files created (set file = continuous eeg in matlab format)
    name_temp=[]; %will be used to look for specific characters in input EDF filename 
    events=[]; %will contain eventlist
   % condition=[]; %
    EEGSET=[]; %will store our input datasets

    %loads the current EDF file and stores it in EEGSET 
    EEGSET=pop_biosig(filesList(i).name); 
    
   %Takes the name corresponding to i (if i = 1, takes the name located row
   %(1) and stores in name_temp. name_temp will be used to name subsequent
   %files 
   name_temp = filesList(i).name;
  
   %if the character in position 3 of the name of the current file stored
   %in name_temp is B, then the variable events will contain the 'EVENTLIST-Block.txt'
   %the eventlist contains the information about which numeric code
   %corresponds to which condition and which bin
    if name_temp(end-4) == '2' 
        events =[currentDirectory '/EVENTLIST_JVA2.txt']; %the backslash before EVENTLIST just allows MATLAB to create a path and find the txt file. Current directory points to the path where the txt file needs to be looked for.
    elseif name_temp(end-4) == '1'
         events =[currentDirectory '/EVENTLIST_JVA1.txt'];
     end
    
 
    %Creates the EVENTLIST structure from the event information given in an edited list of events regarding
    %the information at EEG.event. The EVENTLIST structure is attached to the EEG structure.
    %explanation  of input parameters chosen:
    %EEGSET: current dataset
    %'AlphanumericCleaning'  is 'on': Delete alphabetic character(s) from alphanumeric event codes (if any).('on'/'off')
    %'BoundaryNumeric', { -99}: Numeric code that string code is to be converted to
    %'BoundaryString', { 'boundary' }: Name of string code that is to be converted
    %'List' = events: name of the text file that contains edited event information
    % 'SendEL2': sends EVENTLIST to EEG structure
    % 'UpdateEEG', 'on': overwrite EEG.event.type using information from EEG.EVENTLIST.eventinfo
    % 'Warning': gives warning about eventlist being overwritten
    EEGSET  = pop_editeventlist( EEGSET , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List',...
        events, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Warning',...
        'on' );
    

    %create epochs
    %Input explanation
    %EEGSET: EEG structure
    %[-204.0  1200.0]: window for epoching in msec
    % [ -204 -4]): window for baseline correction in msec
    EEGSET = pop_epochbin( EEGSET , [-204.0  1200.0],  [ -204 -4]);
    
    %name of set will be name of current EDF file
    nameset = filesList(i).name;
    
    % save set with eventlist an epoch information for both participants in
    % one file in directory
    EEGSET = pop_saveset( EEGSET, nameset,[currentDirectory]);
   
    
%%
%Now we will split the file and create one for each participant

%Loop will run twice once for j=1, one for j=2
%When j=1, we will select channels that correspond to human 1 (first half
%of the channels), when j=2 we will select de second half of the channels.
%j is defined here by the line after 'for'
  for j=1:2  
    %i%initializing variables, "=[]" creates empty array in workspace,
    %first iterance of variable = defines the variable and allows us to use
    %it later in the script
    h=0; %
    EEG=[];
    ERP=[];
    name_temp=[];
    nameerp=[];
    exportname=[];
    electrodes=[];
    frontals=[];
    placingelectrode=[];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   %name_temp takes file name of current EEG 
   name_temp = filesList(i).name;
   
   %name_temp becomes  name of current file without the extension (.EDF)
   name_temp = name_temp(1:end-4);  %name_temp = name_temp([1:length(name_temp)-4]);

    if j==1 % human 1 
    EEG=EEGSET
        nameset = [name_temp 'H1'];
      electrodes=[7:8 10:16 20:21 23:26 28:31 33:34]; %22 19 32       %defines which electrodes are included for H1 apart from frontal elec  
      frontals = [4:6];%3 6 %defines frontal electrodes (processing parameters are more strict for frontals) %
      placingelectrode = {'nch1 = ch3 label Fp2',  'nch2 = ch4 label Fp1',  'nch3 = ch5 label F8',  'nch4 = ch6 label F7',...
                        'nch5 = ch7 label Fz',  'nch6 = ch8 label Cz',  'nch7 = ch10 label Pz',  'nch8 = ch11 label P4',  'nch9 = ch12 label P3',  'nch10 = ch13 label T6',...
                        'nch11 = ch14 label T5',  'nch12 = ch15 label T4',  'nch13 = ch16 label T3',  'nch14 = ch19 label F4',  'nch15 = ch20 label F3',...
                        'nch16 = ch21 label Ft8',  'nch17 = ch22 label Ft7',  'nch18 = ch23 label Fc4',  'nch19 = ch24 label Fc3',  'nch20 = ch25 label Fcz',  'nch21 = ch26 label C4',...
                        'nch22 = ch28 label C3',  'nch23 = ch29 label Tp8',  'nch24 = ch30 label Tp7',  'nch25 = ch31 label Cp3',  'nch26 = ch32 label Cp4',...
                        'nch27 = ch33 label O2',  'nch28 = ch34 label O1'}; %exclude unused channels (ch1, ch2, ch9, ch17, ch 18 ch27 etc) and create the liste of 28 channels
   
                    EEG = pop_eegchanoperator(EEG, placingelectrode); %placing electrodes
       
                    EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Standard-10-20-cap81-28.ced']);%load channel location info
            EEG = pop_saveset(EEG,[nameset],[currentDirectory]) %save set
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
            
    elseif j==2 %human 2 %same but for the other participant and second half of channel matrix
       EEG=EEGSET
       %nameset = [name_temp 'H2' '.erp'];
        nameset = [name_temp 'H2'];
        electrodes= [43:44 46:52 55 57:62 64:70]; %56
        frontals= [ 41:42]; %39 40
                placingelectrode = {'nch1 = ch39 label Fp2',  'nch2 = ch40 label Fp1',  'nch3 = ch41 label F8',  'nch4 = ch42 label F7',...
                        'nch5 = ch43 label Fz',  'nch6 = ch44 label Cz',  'nch7 = ch46 label Pz',  'nch8 = ch47 label P4',  'nch9 = ch48 label P3',  'nch10 = ch49 label T6',...
                        'nch11 = ch50 label T5',  'nch12 = ch51 label T4',  'nch13 = ch52 label T3',  'nch14 = ch55 label F4',  'nch15 = ch56 label F3',...
                        'nch16 = ch57 label Ft8',  'nch17 = ch58 label Ft7',  'nch18 = ch59 label Fc4',  'nch19 = ch60 label Fc3',  'nch20 = ch61 label Fcz',...
                        'nch21 = ch62 label C4',  'nch22 = ch64 label C3',  'nch23 = ch65 label Tp8',  'nch24 = ch66 label Tp7',  'nch25 = ch67 label Cp3',  'nch26 = ch68 label Cp4',...
                        'nch27 = ch69 label O2',  'nch28 = ch70 label O1'}; % exclude electrodes: ch45, ch53, ch54, ch63, 
   EEG = pop_eegchanoperator(EEG, placingelectrode); %placing electrodes
       
    EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Standard-10-20-cap81-28.ced']);
                        EEG = pop_saveset(EEG,[nameset],[currentDirectory]) %save set
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );                
    
    
    %% 
    if j==1 % human 1 
      EEG=EEGSET
      nameerp = ['1HZ_' name_temp 'H1' '.set'];
      electrodes=[7:8 10:16 20:21 23:26 28:31 33:34]; %22 19 32       %defines which electrodes are included for H1 apart from frontal elec  
      frontals = [4:6];%3 6 %defines frontal electrodes (processing parameters are more strict for frontals) %
      placingelectrode = {'nch1 = ch3 label Fp2',  'nch2 = ch4 label Fp1',  'nch3 = ch5 label F8',  'nch4 = ch6 label F7',...
                        'nch5 = ch7 label Fz',  'nch6 = ch8 label Cz',  'nch7 = ch10 label Pz',  'nch8 = ch11 label P4',  'nch9 = ch12 label P3',  'nch10 = ch13 label T6',...
                        'nch11 = ch14 label T5',  'nch12 = ch15 label T4',  'nch13 = ch16 label T3',  'nch14 = ch19 label F4',  'nch15 = ch20 label F3',...
                        'nch16 = ch21 label Ft8',  'nch17 = ch22 label Ft7',  'nch18 = ch23 label Fc4',  'nch19 = ch24 label Fc3',  'nch20 = ch25 label Fcz',  'nch21 = ch26 label C4',...
                        'nch22 = ch28 label C3',  'nch23 = ch29 label Tp8',  'nch24 = ch30 label Tp7',  'nch25 = ch31 label Cp3',  'nch26 = ch32 label Cp4',...
                        'nch27 = ch33 label O2',  'nch28 = ch34 label O1'}; %exclude unused channels (ch1, ch2, ch9, ch17, ch 18 ch27 etc) and create the liste of 28 channels
   
                    EEG = pop_eegchanoperator(EEG, placingelectrode); %placing electrodes
            % filter data
            EEGSET = pop_eegfiltnew( EEGSET, 1, [], [], false, [], 0);
            EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Standard-10-20-cap81-28.ced']);%load channel location info
            EEG = pop_saveset(EEG,[nameerp],[currentDirectory]) %save set
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
             
    elseif j==2 %human 2 %same but for the other participant and second half of channel matrix
        EEG=EEGSET
         nameerp = ['1HZ_' name_temp 'H2' '.set'];
        electrodes= [43:44 46:52 55 57:62 64:70]; %56
        frontals= [ 41:42]; %39 40
        placingelectrode = {'nch1 = ch39 label Fp2',  'nch2 = ch40 label Fp1',  'nch3 = ch41 label F8',  'nch4 = ch42 label F7',...
                        'nch5 = ch43 label Fz',  'nch6 = ch44 label Cz',  'nch7 = ch46 label Pz',  'nch8 = ch47 label P4',  'nch9 = ch48 label P3',  'nch10 = ch49 label T6',...
                        'nch11 = ch50 label T5',  'nch12 = ch51 label T4',  'nch13 = ch52 label T3',  'nch14 = ch55 label F4',  'nch15 = ch56 label F3',...
                        'nch16 = ch57 label Ft8',  'nch17 = ch58 label Ft7',  'nch18 = ch59 label Fc4',  'nch19 = ch60 label Fc3',  'nch20 = ch61 label Fcz',...
                        'nch21 = ch62 label C4',  'nch22 = ch64 label C3',  'nch23 = ch65 label Tp8',  'nch24 = ch66 label Tp7',  'nch25 = ch67 label Cp3',  'nch26 = ch68 label Cp4',...
                        'nch27 = ch69 label O2',  'nch28 = ch70 label O1'}; % exclude electrodes: ch45, ch53, ch54, ch63, 
      EEG = pop_eegchanoperator(EEG, placingelectrode); %placing electrodes
            % filter data
            EEGSET = pop_eegfiltnew( EEGSET, 1, [], [], false, [], 0);
             EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Standard-10-20-cap81-28.ced']);%load channel location info
            EEG = pop_saveset(EEG,[nameerp],[currentDirectory]) %save set
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    end
  end
  end
end
 

%% Human 1 (ICA Artifact rejection, Creation of ERP) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
nametemp1hz=['1HZ_'  'H' '.erp']
    j=1; % participant 1
    
    EEG = pop_loadset('filename',['1HZ_' name_temp(3:5) '_H' int2str(j) '.set'],'filepath',[pwd]); %load 1hz dataset for ICA
    nameerp = [name_temp(3:5) '_S' int2str(j) '.erp'];
    nameset = [name_temp(3:5) '_S' int2str(j) '.set'];
    EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Standard-10-20-Cap8128.ced']);%load channel location info
    
    %automatic channel rejection
    %pop_rejchan(EEG)
    EEG = pop_rejchan(EEG, 'elec',[1:28],'measure','prob','norm','on','threshold',5); %automatic rejection parameters
    %  fprintf('If *bad* channels exist, remove them from brackets in pop_runica')
    %% run ICA
    %!!! Chanind remove *bad* electrode in Pop up (or if ICA automated, remove from brackets to run e.g.[1:23 25:28] %24)
    EEG = pop_runica( EEG )
    EEG = pop_saveset( EEG, 'filename',['ICA_1HZ_' name_temp(3:5) '_S' int2str(j) '.set'],'filepath',[pwd ]); %save set
    
    %ICA activation matrix
    TMP.icawinv = EEG.icawinv;
    TMP.icasphere = EEG.icasphere;
    TMP.icaweights = EEG.icaweights;
    TMP.icachansind = EEG.icachansind;
    
    % apply matrix to 0.1hz dataset
    clear EEG;
    
    EEG = pop_loadset('filename', ['0.1HZ_' name_temp(3:5) '_S' int2str(j) '.set'], 'filepath', [pwd]); %load 0.1hz .set
    EEG.icawinv = TMP.icawinv;
    EEG.icasphere = TMP.icasphere;
    EEG.icaweights = TMP.icaweights;
    EEG.icachansind = TMP.icachansind;
    clear TMP;
    EEG = pop_saveset(EEG, 'filename',['ICA_0.1HZ_' name_temp(3:5) '_S' int2str(j) '.set'], 'filepath', [pwd]); %save 0.1hz+ICA matrix .set
    
    %% !!! when 'reject component' window pops up, before rejecting need to label components manually (precaution)
    EEG = pop_loadset('filename', ['ICA_0.1HZ_' name_temp(3:5) '_S' int2str(j) '.set'], 'filepath', [pwd]);
    %IC component rejection
    EEG=iclabel(EEG);
    noisethreshold = [0 0;0.9 1; 0.9 1; 0 0; 0 0; 0 0; 0 0]; %IC label parameters: 90% Muscle and Eye probability;
    EEG = pop_icflag(EEG, noisethreshold);
    pop_viewprops (EEG, 0)
    pause
    % remove bad component(s)
    EEG = pop_subcomp( EEG ); %
    % save
    EEG = pop_saveset(EEG, 'filename',['ICs_ICA_0.1HZ_' name_temp(3:5) '_S' int2str(j) '.set'], 'filepath', [pwd]); %set 0.1hz filter + ICA + bad ICs removed
    
    % check bad channels again
    EEG = pop_rejchan(EEG)
   

%% artifact detection loop
clear

for j=1

        EEG=[];
        ERP=[];
        EEGSET=[];
        name_temp=[];
        nameset=[];
        nameerp = [];
        exportname=[];
        electrodes=[];
        placingelectrode=[];
        EEG=EEGSET;
        
        if j==1;
            searchFilter01hz = '*.set';
            %currentDirectory01hz = [pwd '/01HZ'];
            FileDirectory01hz = [pwd '/ICA1'];
            set01FileDirectory = fullfile(FileDirectory01hz);
            addpath( set01FileDirectory );
            searchString01hz = [set01FileDirectory, '/', searchFilter01hz];
            Filelist01hz = dir(searchString01hz);
            N = length(Filelist01hz) ;
            EEGSET = cell(1,N) ;
            
           
        elseif j==2;
            searchFilter01hz = '*.set';
            %currentDirectory01hz = [pwd '/01HZ'];
            FileDirectory01hz = [pwd '/ICA2' ];
            set01FileDirectory = fullfile(FileDirectory01hz);
            addpath( set01FileDirectory );
            searchString01hz = [set01FileDirectory, '/', searchFilter01hz];
            Filelist01hz = dir(searchString01hz);
            N = length(Filelist01hz) ;
            EEGSET = cell(1,N) ;
        end
   %%
    % Artifact detection
    %Now, we remove artifacts from the data. 
    %EEG can be contaminated in frequency or time domain by artifacts that are resulted 
    %from internal sources of physiologic activities and movement of the subject and/or external 
    %sources of environmental interferences, equipment, movement of
    %electrodes and cables.
%      electrodes=[7:8 10:16 19:26 28:34];%defines which electrodes are included for H1 apart from frontal elec  
%      frontals = [3:6]; 
% electrodes=[7:8 10:16 20:21 23:26 28:31 33:34]; %22 19 32  
    
%    Mark epochs containing activity above an upper threshold and below a
%    lower threshold [ -75 75] uV for channels defined aboved in
%    'electrodes', in time window  [ -204 1200]. Will flag the trials  in the EEG structure. 
    EEG  = pop_artextval( EEGSET , 'Channel', electrodes, 'Flag',  1, 'Threshold', [ -75 75], 'Twindow',...
        [ -204 1200] );
    
    %Same but for for fp1 fp2 f7 f8, threshold is [ -100 100] instead of [ -75 75]
    EEG  = pop_artextval( EEG , 'Channel', frontals, 'Flag',  1, 'Threshold', [ -100 100], 'Twindow',...
        [ -204 1200] );
        
    %removes data where there is a flatline at any electrode for more
    %than 100ms
    EEG  = pop_artflatline( EEG , 'Channel', electrodes, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow',...
        [ -204 1200] );
    %same for frontal electrodes
    EEG  = pop_artflatline( EEG , 'Channel', frontals, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow',...
        [ -204 1200] );
    %saves EEG set in the current directory under the name stored in
    %variable 'nameerp' with the prefix 'AR'
    EEG = pop_saveset( EEG, ['AR' nameerp] ,[currentDirectory]);
    
   % compute erp, this function averages bin-epoched EEG datasets.
   % Input parameters explanation
   %'Criterion' = good: means that epochs marked during artifact detection
   %are excluded.
   %SEM: standard error of the mean included.
    ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' );
    
    % placing the electrodes for plot
     ERP = pop_erpchanoperator( ERP, placingelectrode );
    
    % load channel location information
    ERP = pop_erpchanedit( ERP, [currentDirectory '/Standard-10-20-cap81-28.ced']);
    
    % Save the erp in current directory
    ERP = pop_savemyerp(ERP, 'erpname',...
        nameerp, 'filename', nameerp, 'filepath', [currentDirectory], 'Warning',...
        'on');
    
    %Create table of ERP artifact detection summary
    ERP = pop_summary_AR_erp_detection(ERP, [currentDirectory '\' nameerp(1:end-4) '.txt']);
    
    ERP = pop_summary_rejectfields(EEG);
    
%  if h==1;
%             break
%         end
        end
%   end
 
%prints message in command window
fprintf(':) done :)');

