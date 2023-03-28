%Script to preprocess data from the SEMI-MIXED experiment.
%Version 2
%Output: Set &a erp files

clear 
close
clc

%%NOM DU EDF A CHANGER
EDFfile ='02SM.EDF'
%if j = 1 script will run for H1, if j=2 script will run for H2
h=2
%%CHANGE: PUT YOUR OWN PATH
path2eeglab ='/Users\jeula\Documents\current subjects\eeglab2021.1' %Here, put your OWN path to EEGLAB
path2fieldtrip ='/Users\jeula\Documents\current subjects\fieldtrip\fieldtrip-20190410' %Here, put your OWN path to FIELDTRIP

addpath(genpath(path2eeglab))

eeglab %open eeglab

%for j=1:2 %participant H1 and H2
%j= 2 %participant H2
%initializing variable %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
storeEEG=[]
events=[];
EEGSET=[];
EEG=[];
electrodes=[];
placingelectrode=[];
name_temp = EDFfile(1:end-4);

if h==1 %H1 %if error: change edf filename or name_temp
    events =[pwd '/EVENTLIST_SMH1.txt'];%eventlist for H1
elseif h == 2 %2
    events =[pwd '/EVENTLIST_SMH2.txt']; %eventlist for H2
end

EEGSET=pop_biosig(EDFfile); %load EDF file
storeEEG.rootfile.filename = name_temp
% load event info
EEGSET  = pop_editeventlist( EEGSET , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List',...
    events, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Warning', 'on' );

EEGSET = pop_epochbin( EEGSET , [-204.0  1000.0],  [ -204 -4]);

%EEG= EEGSET
%EEGSET = pop_saveset( EEGSET, nameset,[pwd]);

%toreEEG.rootfile = EEGSET

electrodes =[5:28];
frontals = [1:4];
if h==1;
    %place electrodes, 31 channels
     placingelectrode = {'nch1 = ch1 label CP2' 'nch2 = ch2 label CP1' 'nch3 = ch3 label Fp2','nch4 = ch4 label Fp1',  'nch5 = ch5 label F8',  'nch6 = ch6 label F7',...
            'nch7 = ch7 label Fz',  'nch8 = ch8 label Cz','nch9 = ch10 label Pz',  'nch10 = ch11 label P4',  'nch11 = ch12 label P3',  'nch12 = ch13 label P8',...
            'nch13 = ch14 label P7',  'nch14 = ch15 label T8',  'nch15 = ch16 label T7', 'nch16 = ch17 label Po10',  'nch17 = ch19 label F4',...
            'nch18 = ch20 label F3',  'nch19 = ch21 label Fc6',  'nch20 = ch22 label Fc5',  'nch21 = ch23 label Fc2',  'nch22 = ch24 label Fc1',  'nch23 = ch25 label C4',...
            'nch24 = ch26 label C3',  'nch25 = ch28 label Tp10',  'nch26 = ch30 label Tp9',  'nch27 = ch31 label Cp6',  'nch28 = ch32 label Cp5',...
            'nch29 = ch33 label O2',  'nch30 = ch34 label O1' 'nch31 = ch35 label Po9'}
    
elseif h==2;
    
     placingelectrode = {'nch1 = ch37 label CP2' 'nch2 = ch38 label CP1' 'nch3 = ch39 label Fp2','nch4 = ch40 label Fp1',  'nch5 = ch41 label F8',  'nch6 = ch42 label F7',...
            'nch7 = ch43 label Fz',  'nch8 = ch44 label Cz','nch9 = ch46 label Pz',  'nch10 = ch47 label P4',  'nch11 = ch48 label P3',  'nch12 = ch49 label P8',...
            'nch13 = ch50 label P7',  'nch14 = ch51 label T8',  'nch15 = ch52 label T7', 'nch16 = ch53 label Po10',  'nch17 = ch55 label F4',...
            'nch18 = ch56 label F3',  'nch19 = ch57 label Fc6',  'nch20 = ch58 label Fc5',  'nch21 = ch59 label Fc2',  'nch22 = ch60 label Fc1',  'nch23 = ch61 label C4',...
            'nch24 = ch62 label C3',  'nch25 = ch64 label Tp10',  'nch26 = ch65 label Tp9',  'nch27 = ch66 label Cp6',  'nch28 = ch67 label Cp5',...
            'nch29 = ch68 label O2',  'nch30 = ch69 label O1' 'nch31 = ch70 label Po9'}
        
    
end
EEG = EEGSET

EEG = pop_eegchanoperator(EEG, placingelectrode);%placing electrodes
EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Cap31elec.ced']);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG,0 );

storeEEG.perSubject.data.original = EEG
storeEEG.perSubject.fileForICA = storeEEG.perSubject.data.original
%EEG1 = pop_saveset( storeEEG.perSubject.data.original, ['1' '.']);
EEG = storeEEG.perSubject.fileForICA
EEG =  pop_eegfiltnew( EEG, 1, [], [], false, [], 0);
storeEEG.perSubject.fileForICA = EEG
%
%ALLEEG =[]
% EEG = pop_saveset( storeEEG.perSubject.fileForICA , ['fileforICA' '.']);
%[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, storeEEG.perSubject.data.original,0 );
%[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG,0);

%% SECTION FOR PARTICIPANT H1 (ICA, Artifact rejection)

%initializing variable
% nameerp = [name_temp(1:2) 'H' int2str(h) '.erp'];
electrodes=[];

% load 1HZ dataset
%
%EEG = pop_loadset('filename',['2' '.set'],'filepath',[pwd]);
%EEG =  storeEEG.perSubject.fileForICA
EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Cap31elec.ced']);
INEEG = storeEEG.perSubject.data.original
% automatic channel rejection: we apply the channel rejection but we don't
% actually click on REJECT the channels (ICA will not work otherwise). This
% is also why the pop_rejchan command we use in the manual one and not the
% automated one (the latter will automatically reject the channels)
pop_rejchan(INEEG) %Change Kurtosis to probability in popup'
%EEG = pop_rejchan(EEG,'elec',[1:31],'threshold',5,'norm','on','measure','prob'); % automated command we do not want

fprintf('If *bad* channels exist, remove them from brackets in pop_runica')

%% run ICA 
EEG = storeEEG.perSubject.fileForICA
% MANUAL MANIPULATION Chanind remove *bad* electrode from brackets to run ica e.g.[1:23 25:28] %24
EEG = pop_runica(EEG, 'icatype', 'runica', 'chanind', [1:29], 'extended',1); % might need to change chanind (reject bad electrodes to run ica)
%EEG = pop_saveset( EEG, 'filename',['ICA_1HZ_' name_temp(1:2) 'H' int2str(h) '.set'],'filepath',[pwd '/output']);
storeEEG.perSubject.fileForICA.ICA= EEG


    TMP.icawinv = EEG.icawinv;
    TMP.icasphere = EEG.icasphere;
    TMP.icaweights = EEG.icaweights;
    TMP.icachansind = EEG.icachansind;
 
	% apply to epoched dataset
	clear EEG;
    
    %CHANGE NAME
%     EEG1 = pop_saveset( storeEEG.perSubject.fileForICA , ['1' '.set'], 'filepath', [pwd]);

%EEG = pop_loadset('filename', ['2' '.set'], 'filepath', [pwd]);
%    
 EEG = storeEEG.perSubject.data.original
    EEG.icawinv = TMP.icawinv;
	EEG.icasphere = TMP.icasphere;
	EEG.icaweights = TMP.icaweights;
	EEG.icachansind = TMP.icachansind;
	clear TMP;
 	%EEG = pop_saveset(EEG, 'filename',['4' int2str(h) '.set'], 'filepath', [pwd]);
%	
storeEEG.perSubject.data.ICA = EEG
    fprintf('For next section: Be careful when removing components. Potential manual check')
   %%
   %%%%OPTIONAL when 'reject component' window pops up, before rejecting need
%to label components manually (PRECAUTION to avoid errors: to make sure
%correct .set file loaded, and that correct components were labeled 90%
%Muscle or Eye probability, other components are not removed.)
 EEG = storeEEG.perSubject.data.ICA
%  EEG = pop_loadset('filename', ['ICA_0.1HZ_' name_temp(1:2) 'H' int2str(h) '.set'], 'filepath', [pwd '\output']);
%  EEG = pop_loadset('filename', ['ICA_0.1HZ_' name_temp(1:2) 'H' int2str(h) '.set'], 'filepath', [pwd '\output']);%exist twice because Matlab bug = .set not loading
 EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Cap31elec.ced']);
 EEG=iclabel(EEG);
 noisethreshold = [0 0;0.9 1; 0.9 1; 0 0; 0 0; 0 0; 0 0]; % !Parameters for removing bad components
	EEG = pop_icflag(EEG, noisethreshold);
%     pop_viewprops (EEG, 0)
%     pause
	% remove bad component(s)
	EEG = pop_subcomp( EEG );
	% save
    storeEEG.perSubject.data.ICs = EEG
 	%EEG = pop_saveset(EEG, 'filename',['5' '.set'], 'filepath', [pwd]);
	
	% check bad channels again
	pop_rejchan(EEG)
    %EEG = pop_rejchan(EEG, 'elec',[1:31] ,'threshold',5,'norm','on','measure','prob'); %parameters for automatic channel rejection
	
     fprintf('For next section: Remove *bad electrodes from brackets')
	%% artifact detection
	% exclude bad electrodes, comment which electrode(s) and restore after
	% participant done
%  EEG =   storeEEG.perSubject.data.ICs
%nameerp = [name_temp(1:2) 'H' int2str(h) '.erp'];
% nameset = [name_temp(1:2) 'H' int2str(h) '.set'];
% 
% EEG = pop_saveset( EEG, ['AR' nameset] ,[pwd]);
 %EEG = pop_loadset(['ICs_ICA_0.1HZ_' name_temp(1:2) 'H' int2str(h) '.set'], 'filepath', [pwd '\output']);  

%eeg_checkset(EEG)

	  frontals = [3:6];
	  electrodes=[1:2 7:29];%ch31 30
	
	   % artifact detection
	    %peak to peak
	    EEG  = pop_artextval( EEG , 'Channel', electrodes, 'Flag',  1, 'Threshold', [ -75 75], 'Twindow',...
	        [ -204 1200] );
	    
	    %peak to peak for fp1 fp2 f7 f8
	    EEG  = pop_artextval( EEG , 'Channel', frontals, 'Flag',  1, 'Threshold', [ -100 100], 'Twindow',...
	        [ -204 1200] );
	        
	    %flat line
	    EEG  = pop_artflatline( EEG , 'Channel', electrodes, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow',...
	        [ -204 1200] );
	    
	    EEG  = pop_artflatline( EEG , 'Channel', frontals, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow',...
	        [ -204 1200] );
	   
	EEG = pop_saveset( EEG, ['AR' nameerp] ,[pwd]);
	    
	     % compute erp
	    ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' );
	    
	    % placing the electrodes for plot
	    % ERP = pop_erpchanoperator( ERP, placingelectrode );
	    
	    % load channel location information
	   % ERP = pop_erpchanedit( ERP, [pwd 'Cap31elec.ced']);
	    
	    % Save the erp
	    ERP = pop_savemyerp(ERP, 'erpname',...
	        nameerp, 'filename', nameerp, 'filepath', [pwd], 'Warning',...
	        'on');
	    
	    ERP = pop_summary_AR_erp_detection(ERP, [pwd '\' nameerp(1:end-4) '.txt']);
	    
	    ERP = pop_summary_rejectfields(EEG);
        
         ERP = pop_ploterps( ERP, [1:4],  1:31 , 'AutoYlim', 'on', 'Axsize', [ 0.13 0.15], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 6 5], 'ChLabel',...
        'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'r-' , 'k-' }, 'LineWidth',  1, 'Maximize',...
        'on', 'Position', [ 80.3 6.76923 106.9 31.9231], 'Style', 'Topo', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale', [ -203.0 1195.0   -200:200:1000 ],...
        'YDir', 'reverse' );
    
    fprintf ('Participant done')
	