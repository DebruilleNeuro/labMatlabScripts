%Script to preprocess Tarlan's data.
%Version 4
%Input: Iwave files (ic.asc.eeglab.data.txt and ic.asc.eeglab.events.txt).
%!!Input file name: Pair number needs to be characters 1:2 (ie paire 1= 01...txt)
%Output: Set &a erp files, preprocessed (Pruned with ICA, 0.1hz/50hz filters applied, artifact rejection done...)

clear all
%close all
clc
% 
EDFfile ='01JVAP1.EDF'

% txtfilename = 'BS110.ic.asc.eeglab.events.txt';
% datafilename = 'BS110.ic.asc.eeglab.data.txt';

path2eeglab ='/Users\jeula\Documents\current subjects\eeglab2021.1' %Here, put your OWN path to EEGLAB
path2fieldtrip ='/Users\jeula\Documents\current subjects\fieldtrip\fieldtrip-20190410' %Here, put your OWN path to FIELDTRIP

addpath(genpath(path2eeglab))
%open eeglab
eeglab

%initializing variable %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ERPSET =[];
ERP =[];
nameset=[];
nameerp = [];
name_temp=[];
events=[];
EEGSET=[];
h=0;
EEG=[];
exportname=[];
electrodes=[];
placingelectrode=[];
nameset = EDFfile;
EEG=EEGSET
name_temp = EDFfile(1:end-4);

if name_temp(end) == '2' 
        events =[pwd '/EVENTLIST_JVA2.txt']; %the backslash before EVENTLIST just allows MATLAB to create a path and find the txt file. Current directory points to the path where the txt file needs to be looked for.
    elseif name_temp(end) == '1'
        events =[pwd '/EVENTLIST_JVA1.txt'];
end

     EEGSET=pop_biosig(EDFfile); 
% EEGSET = pop_importdata('dataformat','ascii','nbchan',28,'data',EDFfile,'srate',256,'pnts',0,'xmin',0,'chanlocs',[pwd '/Standard-10-20-Cap81-28.ced']);
% 
    % load event info
    EEGSET  = pop_editeventlist( EEGSET , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List',...
        events, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Warning', 'on' );
EEGSET = pop_epochbin( EEGSET , [-204.0  1000.0],  [ -204 -4]);

% savefile
EEGSET = pop_saveset( EEGSET, nameset,[pwd]);


% Selecting the subject
for j=1:2
% human 1 0,1hz 50hz filters
if j==1;
EEG=EEGSET

nameset = [name_temp '_H1' '.'];
nameerp = [name_temp '_H1' '.erp'];
electrodes =[5:28];
frontals = [1:4];
placingelectrode = {'nch1 = ch3 label Fp2',  'nch2 = ch4 label Fp1',  'nch3 = ch5 label F8',  'nch4 = ch6 label F7',...
                        'nch5 = ch7 label Fz',  'nch6 = ch8 label Cz',  'nch7 = ch10 label Pz',  'nch8 = ch11 label P4',  'nch9 = ch12 label P3',  'nch10 = ch13 label T6',...
                        'nch11 = ch14 label T5',  'nch12 = ch15 label T4',  'nch13 = ch16 label T3',  'nch14 = ch19 label F4',  'nch15 = ch20 label F3',...
                        'nch16 = ch21 label Ft8',  'nch17 = ch22 label Ft7',  'nch18 = ch23 label Fc4',  'nch19 = ch24 label Fc3',  'nch20 = ch25 label Fcz',  'nch21 = ch26 label C4',...
                        'nch22 = ch28 label C3',  'nch23 = ch29 label Tp8',  'nch24 = ch30 label Tp7',  'nch25 = ch31 label Cp3',  'nch26 = ch32 label Cp4',...
                        'nch27 = ch33 label O2',  'nch28 = ch34 label O1'}; %exclude unused channels (ch1, ch2, ch9, ch17, ch 18 ch27 etc) and create the liste of 28 channels

EEG = pop_eegchanoperator(EEG, placingelectrode);%placing electrodes
EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/28elecH1.ced']);
% filter data
% EEGSET = pop_eegfiltnew( EEGSET, [], 50, [], false, [], 0); %50hz
% EEGSET = pop_eegfiltnew( EEGSET, 0.1, [], [], false, [], 0); %0.1hz
EEG = pop_saveset(EEG,[nameset],[pwd]) %save
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

EEG=EEGSET
nameset = ['1HZ_' name_temp '_H1' '.'];
electrodes=[5:28];
frontals = [1:4];
placingelectrode = {'nch1 = ch3 label Fp2',  'nch2 = ch4 label Fp1',  'nch3 = ch5 label F8',  'nch4 = ch6 label F7',...
                        'nch5 = ch7 label Fz',  'nch6 = ch8 label Cz',  'nch7 = ch10 label Pz',  'nch8 = ch11 label P4',  'nch9 = ch12 label P3',  'nch10 = ch13 label T6',...
                        'nch11 = ch14 label T5',  'nch12 = ch15 label T4',  'nch13 = ch16 label T3',  'nch14 = ch19 label F4',  'nch15 = ch20 label F3',...
                        'nch16 = ch21 label Ft8',  'nch17 = ch22 label Ft7',  'nch18 = ch23 label Fc4',  'nch19 = ch24 label Fc3',  'nch20 = ch25 label Fcz',  'nch21 = ch26 label C4',...
                        'nch22 = ch28 label C3',  'nch23 = ch29 label Tp8',  'nch24 = ch30 label Tp7',  'nch25 = ch31 label Cp3',  'nch26 = ch32 label Cp4',...
                        'nch27 = ch33 label O2',  'nch28 = ch34 label O1'}; %exclude unused channels (ch1, ch2, ch9, ch17, ch 18 ch27 etc) and create the liste of 28 channels
% placingelectrode = {'nch1 = ch1 label Fp2',  'nch2 = ch2 label Fp1',  'nch3 = ch3 label F8',  'nch4 = ch4 label F7',...
%     'nch5 = ch5 label Fz',  'nch6 = ch6 label Cz',  'nch7 = ch7 label Pz',  'nch8 = ch8 label P4',  'nch9 = ch9 label P3',  'nch10 = ch10 label T6',...
%     'nch11 = ch11 label T5',  'nch12 = ch12 label T4',  'nch13 = ch13 label T3',  'nch14 = ch14 label F4',  'nch15 = ch15 label F3',...
%     'nch16 = ch16 label Ft8',  'nch17 = ch17 label Ft7',  'nch18 = ch18 label Fc4',  'nch19 = ch19 label Fc3',  'nch20 = ch20 label Fcz',  'nch21 = ch21 label C4',...
%     'nch22 = ch22 label C3',  'nch23 = ch23 label Tp8',  'nch24 = ch24 label Tp7',  'nch25 = ch25 label Cp4',  'nch26 = ch26 label Cp3',...
%     'nch27 = ch27 label O2',  'nch28 = ch28 label O1'};
EEG = pop_eegchanoperator(EEG, placingelectrode); %placing electrodes
% filter data
EEGSET = pop_eegfiltnew( EEGSET, 1, [], [], false, [], 0);
EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/28elecH1.ced']);%load channel location info
EEG = pop_saveset(EEG,[nameset],[pwd]) %save set
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

elseif j==2;
    
EEG=EEGSET
nameset = [name_temp '_H2' '.'];
nameerp = [name_temp '_H2' '.erp'];
electrodes =[5:28];
frontals = [1:4];
placingelectrode = {'nch1 = ch39 label Fp2',  'nch2 = ch40 label Fp1',  'nch3 = ch41 label F8',  'nch4 = ch42 label F7',...
                        'nch5 = ch43 label Fz',  'nch6 = ch44 label Cz',  'nch7 = ch46 label Pz',  'nch8 = ch47 label P4',  'nch9 = ch48 label P3',  'nch10 = ch49 label T6',...
                        'nch11 = ch50 label T5',  'nch12 = ch51 label T4',  'nch13 = ch52 label T3',  'nch14 = ch55 label F4',  'nch15 = ch56 label F3',...
                        'nch16 = ch57 label Ft8',  'nch17 = ch58 label Ft7',  'nch18 = ch59 label Fc4',  'nch19 = ch60 label Fc3',  'nch20 = ch61 label Fcz',...
                        'nch21 = ch62 label C4',  'nch22 = ch64 label C3',  'nch23 = ch65 label Tp8',  'nch24 = ch66 label Tp7',  'nch25 = ch67 label Cp4',  'nch26 = ch68 label Cp3',...
                        'nch27 = ch69 label O2',  'nch28 = ch70 label O1'}; % exclude electrodes: ch45, ch53, ch54, ch63, 

EEG = pop_eegchanoperator(EEG, placingelectrode);%placing electrodes
EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/28elecH2.ced']);
% filter data
% EEGSET = pop_eegfiltnew( EEGSET, [], 50, [], false, [], 0); %50hz
% EEGSET = pop_eegfiltnew( EEGSET, 0.1, [], [], false, [], 0); %0.1hz
EEG = pop_saveset(EEG,[nameset],[pwd]) %save
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

EEG=EEGSET
nameset = ['1HZ_' name_temp '_H2' '.'];
electrodes=[5:28];
frontals = [1:4];
placingelectrode = {'nch1 = ch39 label Fp2',  'nch2 = ch40 label Fp1',  'nch3 = ch41 label F8',  'nch4 = ch42 label F7',...
                        'nch5 = ch43 label Fz',  'nch6 = ch44 label Cz',  'nch7 = ch46 label Pz',  'nch8 = ch47 label P4',  'nch9 = ch48 label P3',  'nch10 = ch49 label T6',...
                        'nch11 = ch50 label T5',  'nch12 = ch51 label T4',  'nch13 = ch52 label T3',  'nch14 = ch55 label F4',  'nch15 = ch56 label F3',...
                        'nch16 = ch57 label Ft8',  'nch17 = ch58 label Ft7',  'nch18 = ch59 label Fc4',  'nch19 = ch60 label Fc3',  'nch20 = ch61 label Fcz',...
                        'nch21 = ch62 label C4',  'nch22 = ch64 label C3',  'nch23 = ch65 label Tp8',  'nch24 = ch66 label Tp7',  'nch25 = ch67 label Cp4',  'nch26 = ch68 label Cp3',...
                        'nch27 = ch69 label O2',  'nch28 = ch70 label O1'}; % exclude electrodes: ch45, ch53, ch54, ch63, 
% placingelectrode = {'nch1 = ch1 label Fp2',  'nch2 = ch2 label Fp1',  'nch3 = ch3 label F8',  'nch4 = ch4 label F7',...
%     'nch5 = ch5 label Fz',  'nch6 = ch6 label Cz',  'nch7 = ch7 label Pz',  'nch8 = ch8 label P4',  'nch9 = ch9 label P3',  'nch10 = ch10 label T6',...
%     'nch11 = ch11 label T5',  'nch12 = ch12 label T4',  'nch13 = ch13 label T3',  'nch14 = ch14 label F4',  'nch15 = ch15 label F3',...
%     'nch16 = ch16 label Ft8',  'nch17 = ch17 label Ft7',  'nch18 = ch18 label Fc4',  'nch19 = ch19 label Fc3',  'nch20 = ch20 label Fcz',  'nch21 = ch21 label C4',...
%     'nch22 = ch22 label C3',  'nch23 = ch23 label Tp8',  'nch24 = ch24 label Tp7',  'nch25 = ch25 label Cp4',  'nch26 = ch26 label Cp3',...
%     'nch27 = ch27 label O2',  'nch28 = ch28 label O1'};
EEG = pop_eegchanoperator(EEG, placingelectrode); %placing electrodes
% filter data
EEGSET = pop_eegfiltnew( EEGSET, 1, [], [], false, [], 0);
EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/28elecH2.ced']);%load channel location info
EEG = pop_saveset(EEG,[nameset],[pwd]) %save set
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
end

end

%% Human 1 (ICA Artifact rejection, Creation of ERP) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%name_temp = '02JVAP1';
%     j==1; % participant 1
    for j=1:2
    EEG = pop_loadset('filename',['1HZ_' name_temp '_H' int2str(j) '.set'],'filepath',[pwd]); %load 1hz dataset for ICA
    nameerp = [name_temp '_H' int2str(j) '.erp'];
    nameset = [name_temp '_H' int2str(j) '.set'];
    if j==1
    EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/28elecH1.ced']);%load channel location info
    elseif j==2
        EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/28elecH2.ced']);%load channel location info
    end
    %automatic channel rejection
    %pop_rejchan(EEG)
    EEG = pop_rejchan(EEG, 'elec',[1:28],'measure','prob','norm','on','threshold',5); %automatic rejection parameters
    %  fprintf('If *bad* channels exist, remove them from brackets in pop_runica')
    EEG = runpca (EEG)
    % run ICA
    %!!! Chanind remove *bad* electrode in Pop up (or if ICA automated, remove from brackets to run e.g.[1:23 25:28] %24)
    EEG = pop_runica( EEG )
    EEG = pop_saveset( EEG, 'filename',['ICA_1HZ_' name_temp '_H' int2str(j) '.set'],'filepath',[pwd ]); %save set
    
    %ICA activation matrix
    TMP.icawinv = EEG.icawinv;
    TMP.icasphere = EEG.icasphere;
    TMP.icaweights = EEG.icaweights;
    TMP.icachansind = EEG.icachansind;
    
    % apply matrix to 0.1hz dataset
    clear EEG;
    
    EEG = pop_loadset('filename', [name_temp '_H' int2str(j) '.set'], 'filepath', [pwd]); %load 0.1hz .set
    EEG.icawinv = TMP.icawinv;
    EEG.icasphere = TMP.icasphere;
    EEG.icaweights = TMP.icaweights;
    EEG.icachansind = TMP.icachansind;
    clear TMP;
    EEG = pop_saveset(EEG, 'filename',['ICA_' name_temp '_H' int2str(j) '.set'], 'filepath', [pwd]); %save 0.1hz+ICA matrix .set
    
    %% !!! when 'reject component' window pops up, before rejecting need to label components manually (precaution)
    EEG = pop_loadset('filename', ['ICA_' name_temp '_H' int2str(j) '.set'], 'filepath', [pwd]);
    %IC component rejection
    EEG=iclabel(EEG);
    noisethreshold = [0 0;0.9 1; 0.9 1; 0 0; 0 0; 0 0; 0 0]; %IC label parameters: 90% Muscle and Eye probability;
    EEG = pop_icflag(EEG, noisethreshold);
    pop_viewprops (EEG, 0)
    pause
    % remove bad component(s)
    EEG = pop_subcomp( EEG ); %
    % save
    EEG = pop_saveset(EEG, 'filename',['ICs_ICA_' name_temp '_H' int2str(j) '.set'], 'filepath', [pwd]); %set 0.1hz filter + ICA + bad ICs removed
    
    % check bad channels again
    EEG = pop_rejchan(EEG)
   
%% artifact detection loop

% EEG=EEGSET
   % EEG = pop_loadset('filename',['ICs_ICA_' name_temp '_H' int2str(j) '.set'],'filepath',[pwd]); %load 1hz dataset for ICA
%      j=1;
%    name_temp = '09JVAP2';
    EEG = pop_loadset('filename',['ICs_ICA_' name_temp '_H' int2str(j) '.set'],'filepath',[pwd]); %load 1hz dataset for ICA
    
    nameerp = [name_temp '_H' int2str(j) '.erp'];
    namesum =[name_temp '_H' int2str(j) ];
    nameset = [name_temp '_H' int2str(j) '.set'];
    %%%!! exclude *bad* electrodes, comment which electrode(s) and restore
    %%%after participant is done
    frontals = [2:4]; %2
    electrodes=[5:28];  %28 take note of which electrode is removed
    
    %peak to peak (frontal elec and other elec)
    EEG  = pop_artextval( EEG , 'Channel', electrodes, 'Flag',  1, 'Threshold', [ -75 75], 'Twindow',[ -204 1000] );
    EEG  = pop_artextval( EEG , 'Channel', frontals, 'Flag',  1, 'Threshold', [ -100 100], 'Twindow',[ -204 1000] );
    
    %flat line (frontal elec and other elec)
    EEG  = pop_artflatline( EEG , 'Channel', electrodes, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow', [ -204 1000] );
    EEG  = pop_artflatline( EEG , 'Channel', frontals, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow', [ -204 1000] );
    
    %close;
    EEG = pop_saveset( EEG, [nameset] ,[pwd]);
    
    %% compute erp
    
    ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' );
    
    % load channel location information
    ERP = pop_erpchanedit( ERP, [pwd '/Standard-10-20-Cap81-28.ced']);
    
    % Save the erp
    ERP = pop_savemyerp(ERP, 'erpname', nameerp, 'filename', nameerp, 'filepath', [pwd], 'Warning', 'on');
    ERP = pop_summary_AR_erp_detection(ERP, [pwd '\' namesum '.txt'])
    
    ERP = pop_summary_rejectfields(EEG);
    
    end 
    clear
    
    fprintf(':) Participant done :)');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%