%Script to preprocess Tarlan's data.
%Version 4
%Input: Iwave files (ic.asc.eeglab.data.txt and ic.asc.eeglab.events.txt).
%!!Input file name: Pair number needs to be characters 1:2 (ie paire 1= 01...txt)
%Output: Set &a erp files, preprocessed (Pruned with ICA, 0.1hz/50hz filters applied, artifact rejection done...)

clear all
close all
clc
% 
EDFfile ='04BH1H2.EDF'
j=1

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

%if name_temp(end) == '2' 
%         events =[pwd '/EVENTLIST_JVA2.txt']; %the backslash before EVENTLIST just allows MATLAB to create a path and find the txt file. Current directory points to the path where the txt file needs to be looked for.
%     elseif name_temp(end) == '1'
        events =[pwd '/EVENTLIST_JVA1.txt'];
% end

     EEGSET=pop_biosig(EDFfile); 
% EEGSET = pop_importdata('dataformat','ascii','nbchan',28,'data',EDFfile,'srate',256,'pnts',0,'xmin',0,'chanlocs',[pwd '/Standard-10-20-Cap81-28.ced']);
% 
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


elseif j==2;
    
EEG=EEGSET
nameset = [name_temp '_H2' '.set'];
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
%     
end

% end

%% Human 1 (ICA Artifact rejection, Creation of ERP) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%name_temp = '02JVAP1';
%     j==1; % participant 1
%     for j=1:2
% % % 
%  nameset = '08BH1apd.set'
%  name_temp ='08BH1apd'
%  %setpath = 'C:\Users\jeula\Documents\current subjects\MATFLO308\18'
%  j==1
    % EEG = pop_loadset('filename',nameset,'filepath',setpath); %load 1hz dataset for ICA
    EEG = pop_loadset('filename',nameset,'filepath',pwd); %load 1hz dataset for ICA
    
    nameerp = [name_temp '_H' int2str(j) '.erp'];
%     nameset = [name_temp '_H' int2str(j) '.set'];
    if j==1
    EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/28elecH1.ced']);%load channel location info
    elseif j==2
        EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/28elecH2.ced']);%load channel location info
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
   
    if j==1
    ERP = pop_erpchanedit( ERP, [pwd '/28elecH1.ced']);
    elseif j==2
    ERP = pop_erpchanedit( ERP, [pwd '/28elecH2.ced']);
    end
    % Save the erp
    ERP = pop_savemyerp(ERP, 'erpname', nameerp, 'filename', nameerp, 'filepath', [pwd], 'Warning', 'on');
    ERP = pop_summary_AR_erp_detection(ERP, [pwd '\' namesum '.txt'])
    
    ERP = pop_summary_rejectfields(EEG);
    
     ERP = pop_loaderp ('filename', nameerp)
    ERP = pop_ploterps( ERP, [1 2],  1:28 , 'AutoYlim', 'on', 'Axsize', [ 0.13 0.15], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 6 5], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'r-' , 'k-' }, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 80.3 6.76923 106.9 31.9231], 'Style', 'Topo', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale', [ -203.0 1195.0   -200:200:1000 ],...
 'YDir', 'reverse' );
    
%     end
%     clear
    
    fprintf(':) Participant done :)');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%