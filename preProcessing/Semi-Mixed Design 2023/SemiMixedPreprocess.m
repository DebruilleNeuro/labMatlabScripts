%Script to preprocess data from the SEMI-MIXED experiment.
%Version 2
%Output: Set &a erp files

clear all
close all
clc

%%NOM DU EDF A CHANGER
EDFfile ='02SM.EDF'
%if j = 1 script will run for H1, if j=2 script will run for H2
j=1
%%CHANGE: PUT YOUR OWN PATH
path2eeglab ='/Users\jeula\Documents\current subjects\eeglab2021.1' %Here, put your OWN path to EEGLAB
path2fieldtrip ='/Users\jeula\Documents\current subjects\fieldtrip\fieldtrip-20190410' %Here, put your OWN path to FIELDTRIP

addpath(genpath(path2eeglab))

eeglab %open eeglab

%for j=1:2 %participant H1 and H2
    %j= 2 %participant H2
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
    
    if j==1 %H1 %if error: change edf filename or name_temp
        events =[pwd '/EVENTLIST_SMH1.txt'];%eventlist for H1
    elseif j == 2 %2
        events =[pwd '/EVENTLIST_SMH2.txt']; %eventlist for H2
    end
    
    EEGSET=pop_biosig(EDFfile); %load EDF file
    
    % load event info
    EEGSET  = pop_editeventlist( EEGSET , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List',...
        events, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Warning', 'on' );
    EEGSET = pop_epochbin( EEGSET , [-204.0  1000.0],  [ -204 -4]);
    
    % savefile
    EEGSET = pop_saveset( EEGSET, nameset,[pwd]);
    
    % human 1 0,1hz 50hz filters
    if j==1;
        EEG=EEGSET
        
        nameset = [name_temp '_H1' '.set'];
        nameerp = [name_temp '_H1' '.erp'];
        electrodes =[5:28];
        frontals = [1:4];
        
        %place electrodes, 31 channels
        placingelectrode = {'nch1 = ch1 label CP2' 'nch2 = ch2 label CP1' 'nch3 = ch3 label Fp2','nch4 = ch4 label Fp1',  'nch5 = ch5 label F8',  'nch6 = ch6 label F7',...
            'nch7 = ch7 label Fz',  'nch8 = ch8 label Cz','nch9 = ch10 label Pz',  'nch10 = ch11 label P4',  'nch11 = ch11 label P3',  'nch12 = ch12 label P8',...
            'nch13 = ch13 label P7',  'nch14 = ch14 label T8',  'nch15 = ch15 label T7', 'nch16 = ch16 label Po10',  'nch17 = ch17 label F4',...
            'nch18 = ch18 label F3',  'nch19 = ch19 label Fc6',  'nch20 = ch20 label Fc5',  'nch21 = ch21 label Fc2',  'nch22 = ch22 label Fc1',  'nch23 = ch23 label C4',...
            'nch24 = ch24 label C3',  'nch25 = ch25 label Tp10',  'nch26 = ch26 label Tp9',  'nch27 = ch27 label Cp6',  'nch28 = ch28 label Cp5',...
            'nch29 = ch29 label O2',  'nch30 = ch30 label O1' 'nch31 = ch31 label O1'}
        
        EEG = pop_eegchanoperator(EEG, placingelectrode);%placing electrodes
        EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Cap31elec.ced']);
        % filter data
        % EEGSET = pop_eegfiltnew( EEGSET, [], 50, [], false, [], 0); %50hz
        % EEGSET = pop_eegfiltnew( EEGSET, 0.1, [], [], false, [], 0); %0.1hz
        EEG = pop_saveset(EEG,[nameset],[pwd]) %save
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        
        
    elseif j==2;
        
        EEG=EEGSET
        nameset = [name_temp '_H2' '.set'];
        nameerp = [name_temp '_H2' '.erp'];
        electrodes =[5:28];
        frontals = [1:4];
        %%CHANGE
        placingelectrode = {'nch1 = ch32 label CP2' 'nch2 = ch2 label CP1' 'nch3 = ch3 label Fp2','nch4 = ch4 label Fp1',  'nch5 = ch5 label F8',  'nch6 = ch6 label F7',...
            'nch7 = ch7 label Fz',  'nch8 = ch8 label Cz','nch9 = ch9 label Pz',  'nch10 = ch10 label P4',  'nch11 = ch11 label P3',  'nch12 = ch12 label P8',...
            'nch13 = ch13 label P7',  'nch14 = ch14 label T8',  'nch15 = ch15 label T7', 'nch16 = ch16 label Po10',  'nch17 = ch17 label F4',...
            'nch18 = ch18 label F3',  'nch19 = ch19 label Fc6',  'nch20 = ch20 label Fc5',  'nch21 = ch21 label Fc2',  'nch22 = ch22 label Fc1',  'nch23 = ch23 label C4',...
            'nch24 = ch24 label C3',  'nch25 = ch25 label Tp10',  'nch26 = ch26 label Tp9',  'nch27 = ch27 label Cp6',  'nch28 = ch28 label Cp5',...
            'nch29 = ch29 label O2',  'nch30 = ch30 label O1' 'nch31 = ch31 label O1'}
        
        EEG = pop_eegchanoperator(EEG, placingelectrode);%placing electrodes
        
        %%CHANGE CHANNEL LOCATION FILE ('/Cap31elec.ced')
        EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Cap31elec.ced']);
        % filter data
        % EEGSET = pop_eegfiltnew( EEGSET, [], 50, [], false, [], 0); %50hz
        % EEGSET = pop_eegfiltnew( EEGSET, 0.1, [], [], false, [], 0); %0.1hz
        EEG = pop_saveset(EEG,[nameset],[pwd]) %save
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        %
    end
    
    % end
    
    %% Human 1 (ICA Artifact rejection, Creation of ERP) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    % EEG = pop_loadset('filename',nameset,'filepath',setpath); %load 1hz dataset for ICA
    EEG = pop_loadset('filename',nameset,'filepath',pwd); %load 1hz dataset for ICA
    
    nameerp = [name_temp '_H' int2str(j) '.erp'];
    %     nameset = [name_temp '_H' int2str(j) '.set'];
    if j==1
        
        %%CHANGE CHANNEL LOCATION FILE ('/Cap31elec.ced')
        EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Cap31elec.ced']);%load channel location info
    elseif j==2
        
        %%CHANGE CHANNEL LOCATION FILE ('/Cap31elec.ced')
        EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Cap31elec.ced']);%load channel location info
    end
    
    %% !!! when 'reject component' window pops up, before rejecting need to label components manually (precaution)
    %AR
    
    nameerp = [name_temp '_H' int2str(j) '.erp'];
    namesum =[name_temp '_H' int2str(j) ];
    nameset = [name_temp '_H' int2str(j) '.set'];
    %%%!! exclude *bad* electrodes, comment which electrode(s) and restore
    %%%after participant is done
    frontals = [1:4]; %2
    electrodes=[5:28];  %18 take note of which electrode is removed
    
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
    
    %     if j==1
    %%MODIFY CED FILE NAME FOR 32 CHANNELS CAPS
    ERP = pop_erpchanedit( ERP, [pwd '/Cap31elec.ced']);
    
    % Save the erp
    ERP = pop_savemyerp(ERP, 'erpname', nameerp, 'filename', nameerp, 'filepath', [pwd], 'Warning', 'on');
    ERP = pop_summary_AR_erp_detection(ERP, [pwd '\' namesum '.txt'])
    
    ERP = pop_summary_rejectfields(EEG);
    
    ERP = pop_loaderp ('filename', nameerp)
    ERP = pop_ploterps( ERP, [1 2],  1:28 , 'AutoYlim', 'on', 'Axsize', [ 0.13 0.15], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 6 5], 'ChLabel',...
        'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'r-' , 'k-' }, 'LineWidth',  1, 'Maximize',...
        'on', 'Position', [ 80.3 6.76923 106.9 31.9231], 'Style', 'Topo', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale', [ -203.0 1195.0   -200:200:1000 ],...
        'YDir', 'reverse' );
    
end
%     clear

fprintf(':) Participants done :)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%