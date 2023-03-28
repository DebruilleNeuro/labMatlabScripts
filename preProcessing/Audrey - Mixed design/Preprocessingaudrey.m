%Version3 (up to date)
%{
%%%%Script to preprocess data for Visage experiments (JPE). 
!READ ME!
Input: Raw eeg data *.edf (eeg continuous)
Output: *.erp, *.set files (event related potentials)

%%%%IMPORTANT Before running ICA channels that were automatically rejected (in pop_rejchan) need to be excluded.
%%%IMPORTANT Need to remove bad electrodes to run
%%%%IMPORTANT Run section per section (in Editor > Run and Advance NOT 'RUN')
%%%%SCRIPT NEEDS TO BE IN 'OUTPUT' folder in current folder. Run script from cd!!. 

-21/06/22
%}

%% 
clear all
%close all
clc

addpath(genpath('C:\Users\jeula\Documents\current subjects\eeglab2021.1'))    

%open eeglab
eeglab

EDFfile ='01SM_3.EDF' 
%if j = 1 script will run for H1, to run for h2 change  to j=2
h=1 %participant H1

% search for .edf file in the current directory
% searchFilter = '*.EDF';
% currentDirectory = pwd;
% asciiFileDirectory = fullfile( currentDirectory);
% addpath( asciiFileDirectory );
% searchString = [asciiFileDirectory, '/', searchFilter];
% filesList = dir(searchString);
% 
% % % Boucle pour lire tout .edf

for j=1:8
    
%     name_temp = filesList(i).name;
 name_temp = EDFfile 

    %initializing variable
    events=[];
    %specify channels
    channels=((j-1)*9+1):j*9;
    
    %start processing data
    %open EDF file in eeglab
    EEGSET=pop_biosig(name_temp, 'channels', channels);
    
 if h==1
       events =[pwd '/EVENTLIST_SMH1.txt'];%not used
%         events =  allevents(
 elseif h == 2
        events =[pwd '/EVENTLIST_SMH2.txt']; %if bug: change edf filename or name_temp 
 end
    
%     
%     % choose the correct event list
%     if name_temp(3) == 'D'
%         events =[currentDirectory '/EVENTLISTMixed2021.txt'];
%     elseif name_temp(3) == 'M'
%         events =[currentDirectory '/EVENTLISTMixed2021.txt'];
%     end
    
    % load event info
    EEGSET  = pop_editeventlist( EEGSET , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List',...
        events, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Warning', 'on' );
    
%     % filter data
%     EEGSET = pop_eegfiltnew( EEGSET, [], 40, [], false, [], 0);
%     EEGSET = pop_eegfiltnew( EEGSET, 0.1, [], [], false, [], 0);
    
    % create epochs
    EEGSET = pop_epochbin( EEGSET , [-205  1200.0],  [ -204 -4]);
    
    %initializing variable
    placingelectrode=[];
    
    EEG=EEGSET;
    
    nameerp = [name_temp(1:2) 'b' int2str(j)];
    if (j==1 || j==5)
        placingelectrode = {'ch1 = ch1 label CP2', 'ch2 = ch2 label CP1', 'ch3 = ch3 label Fp2',  'ch4 = ch4 label Fp1',  'ch5 = ch5 label F8',  'ch6 = ch6 label F7', 'ch7 = ch7 label Fz',  'ch8 = ch8 label Cz'};
    elseif (j==2 || j==6)
        placingelectrode = {'ch1 = ch1 label Pz',  'ch2 = ch2 label P4',  'ch3 = ch3 label P3',  'ch4 = ch4 label P8', 'ch5 = ch5 label P7',  'ch6 = ch6 label T8',  'ch7 = ch7 label T7', 'ch8 = ch8 label Po10'};
    elseif (j==3 || j==7)
        placingelectrode = {'ch1 = ch1 label F4', 'ch2 = ch2 label F3',  'ch3 = ch3 label Fc6',  'ch4 = ch4 label Fc5',  'ch5 = ch5 label Fc2',  'ch6 = ch6 label Fc1',  'ch7 = ch7 label Fc1', 'ch8 = ch8 label C4'};
    elseif (j==4 || j==8)
        placingelectrode = {'ch1 = ch1 label C3', 'ch2 = ch2 label Tp10',  'ch3 = ch3 label Tp9',  'ch4 = ch4 label Cp6',  'ch5 = ch5 label Cp5', 'ch6 = ch6 label O2',  'ch7 = ch7 label O1', 'ch8 = ch8 label Po9'};
    end
    
    EEG = pop_eegchanoperator(EEG, placingelectrode);
    nameerp = [name_temp(1:2) 'b' int2str(j)];
    EEG = pop_saveset( EEG, ['0.1HZ_' nameerp '.'] , [pwd '/output']);
    
end

% merge datasets (use of function merge_eeg_sets in 'output' folder. If bug
% here: check function name, check path in function
    name_temp =EDFfile
    nameH1 = ['0.1HZ_' name_temp(1:2) 'H1.'];
    nameH2 = ['0.1HZ_' name_temp(1:2) 'H2.'];
    merge_eeg_sets(['0.1HZ_' name_temp(1:2) 'b1.set'], ['0.1HZ_' name_temp(1:2) 'b2.set'], ['0.1HZ_' name_temp(1:2) 'b3.set'], ['0.1HZ_' name_temp(1:2) 'b4.set'], nameH1);
    merge_eeg_sets(['0.1HZ_' name_temp(1:2) 'b5.set'], ['0.1HZ_' name_temp(1:2) 'b6.set'], ['0.1HZ_' name_temp(1:2) 'b7.set'], ['0.1HZ_' name_temp(1:2) 'b8.set'], nameH2);

%%
clear all
close all
clc

%open eeglab
eeglab
% 
% % search for .edf file in the current directory
% searchFilter = '*.EDF';
% currentDirectory = pwd;
% asciiFileDirectory = fullfile( currentDirectory);
% addpath( asciiFileDirectory );
% searchString = [asciiFileDirectory, '/', searchFilter];
% filesList = dir(searchString);
% 
% % Boucle pour lire tout .edf
% for i=1:length(filesList)
%     file_name(i)= fopen(filesList(i).name);% lire le fichier
% end

% i=1:length(file_name);
EDFfile ='01SM_3.EDF' 
%if j = 1 script will run for H1, to run for h2 change  to j=2
h=1 %participant H1



for j=1:8
    
%     name_temp = filesList(i).name;
name_temp = EDFfile 

    %initializing variable
    events=[];
    %specify channels
    channels=((j-1)*9+1):j*9;
    
    %start processing data
    %open EDF file in eeglab
%     EEGSET=pop_biosig(filesList(i).name, 'channels', channels);
 EEGSET=pop_biosig(name_temp, 'channels', channels);
     if h==1
       events =[pwd '/EVENTLIST_SMH1.txt'];%not used
%         events =  allevents(
 elseif h == 2
        events =[pwd '/EVENTLIST_SMH2.txt']; %if bug: change edf filename or name_temp 
 end
    
%     % choose the correct event list
%     if name_temp(3) == 'D' 
%         events =[currentDirectory '/EVENTLISTMixed2021.txt'];%not used
%     elseif name_temp(3) == 'M'
%         events =[currentDirectory '/EVENTLISTMixed2021.txt']; %if bug: change edf filename or name_temp 
%     end
    
    % load event info
    EEGSET  = pop_editeventlist( EEGSET , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List',...
        events, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Warning', 'on' );
    
    % filter data
    EEGSET = pop_eegfiltnew( EEGSET, 1, [], [], false, [], 0);
    
    % create epochs
    EEGSET = pop_epochbin( EEGSET , [-204.0  1200.0],  [ -204 -4]);
    
    %initializing variable
  placingelectrode=[];
    
    EEG=EEGSET;
    
    nameerp = [name_temp(1:2) 'b' int2str(j)];
    if (j==1 || j==5)
        placingelectrode = {'ch1 = ch1 label CP2', 'ch2 = ch2 label CP1', 'ch3 = ch3 label Fp2',  'ch4 = ch4 label Fp1',  'ch5 = ch5 label F8',  'ch6 = ch6 label F7', 'ch7 = ch7 label Fz',  'ch8 = ch8 label Cz'};
    elseif (j==2 || j==6)
        placingelectrode = {'ch1 = ch1 label Pz',  'ch2 = ch2 label P4',  'ch3 = ch3 label P3',  'ch4 = ch4 label P8', 'ch5 = ch5 label P7',  'ch6 = ch6 label T8',  'ch7 = ch7 label T7', 'ch8 = ch8 label Po10'};
    elseif (j==3 || j==7)
        placingelectrode = {'ch1 = ch1 label F4', 'ch2 = ch2 label F3',  'ch3 = ch3 label Fc6',  'ch4 = ch4 label Fc5',  'ch5 = ch5 label Fc2',  'ch6 = ch6 label Fc1',  'ch7 = ch7 label Fc1', 'ch8 = ch8 label C4'};
    elseif (j==4 || j==8)
        placingelectrode = {'ch1 = ch1 label C3', 'ch2 = ch2 label Tp10',  'ch3 = ch3 label Tp9',  'ch4 = ch4 label Cp6',  'ch5 = ch5 label Cp5', 'ch6 = ch6 label O2',  'ch7 = ch7 label O1', 'ch8 = ch8 label Po9'};
    end
    
    EEG = pop_eegchanoperator(EEG, placingelectrode);
    
    
     nameerp = [name_temp(1:2) 'b' int2str(j)];
     EEG = pop_saveset( EEG, ['1HZ_' nameerp],[pwd '/output']);
     
end

% name_temp = filesList(i).name;
nameH1 = ['1HZ_' name_temp(1:2) 'H1'];
nameH2 = ['1HZ_' name_temp(1:2) 'H2'];
merge_eeg_sets(['1HZ_' name_temp(1:2) 'b1.set'], ['1HZ_' name_temp(1:2) 'b2.set'], ['1HZ_' name_temp(1:2) 'b3.set'], ['1HZ_' name_temp(1:2) 'b4.set'], nameH1);
merge_eeg_sets(['1HZ_' name_temp(1:2) 'b5.set'], ['1HZ_' name_temp(1:2) 'b6.set'], ['1HZ_' name_temp(1:2) 'b7.set'], ['1HZ_' name_temp(1:2) 'b8.set'], nameH2);

% remove channels

%%CHANGE "PLACING ELECTRODE" EVERY TIME IT APPEARS. COMPARE WITH CHANNEL LIST "CAPSEDITED" 
placingelectrode = {'nch1 = ch1 label CP2' 'nch2 = ch2 label CP1' 'nch3 = ch3 label Fp2','nch4 = ch4 label Fp1',  'nch5 = ch5 label F8',  'nch6 = ch6 label F7',...
                        'nch7 = ch7 label Fz',  'nch8 = ch8 label Cz','nch9 = ch9 label Pz',  'nch10 = ch10 label P4',  'nch11 = ch11 label P3',  'nch12 = ch12 label P8',...
                        'nch13 = ch13 label P7',  'nch14 = ch14 label T8',  'nch15 = ch15 label T7', 'nch16 = ch16 label Po10',  'nch17 = ch17 label F4',...
                        'nch18 = ch18 label F3',  'nch19 = ch19 label Fc6',  'nch20 = ch20 label Fc5',  'nch21 = ch21 label Fc2',  'nch22 = ch22 label Fc1',  'nch23 = ch23 label C4',...
                        'nch24 = ch24 label C3',  'nch25 = ch25 label Tp10',  'nch26 = ch26 label Tp9',  'nch27 = ch27 label Cp6',  'nch28 = ch28 label Cp5',...
                        'nch29 = ch29 label O2',  'nch30 = ch30 label O1'}

%%

for j=1:2
    
    EEG = pop_loadset('filename',['1HZ_' name_temp(1:2) 'b' int2str(j) '.set'],'filepath',[pwd '\output']);
    EEG = pop_eegchanoperator(EEG, placingelectrode);
    EEG = pop_saveset( EEG, ['ChRm_1HZ_' name_temp(1:2) 'H' int2str(j) '.set'],[pwd '/output']);

    EEG = pop_loadset('filename',['0.1HZ_' name_temp(1:2) 'b' int2str(j) '.set'],'filepath',[pwd '\output']);
    EEG = pop_eegchanoperator(EEG, placingelectrode);
    EEG = pop_saveset( EEG, ['ChRm_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'],[pwd '/output']);
    
end

 
%% SECTION FOR PARTICIPANT H1 (ICA, Artifact rejection)

j=1;

%initializing variable
nameerp = [name_temp(1:2) 'H' int2str(j) '.erp'];
electrodes=[];

% load 1HZ dataset
EEG = pop_loadset('filename',['ChRm_1HZ_' name_temp(1:2) 'H' int2str(j) '.set'],'filepath',[pwd '\output']);
EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/capsedited.ced']);

% automatic channel rejection
pop_rejchan(EEG) %Change Kurtosis to probability in popup'
EEG = pop_rejchan(EEG, 'elec',[1:30] ,'threshold',5,'norm','on','measure','prob');

fprintf('If *bad* channels exist, remove them from brackets in pop_runica')

%% run ICA 
% MANUAL MANIPULATION Chanind remove *bad* electrode from brackets to run ica e.g.[1:23 25:28] %24
EEG = pop_runica(EEG, 'icatype', 'runica', 'chanind', [1:30], 'extended',1); % might need to change chanind (reject bad electrodes to run ica)
EEG = pop_saveset( EEG, 'filename',['ICA_1HZ_' name_temp(1:2) 'H' int2str(j) '.set'],'filepath',[pwd '/output']);

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
   %%%%OPTIONAL when 'reject component' window pops up, before rejecting need
%to label components manually (PRECAUTION to avoid errors: to make sure
%correct .set file loaded, and that correct components were labeled 90%
%Muscle or Eye probability, other components are not removed.)
 EEG = pop_loadset('filename', ['ICA_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath', [pwd '\output']);
 EEG = pop_loadset('filename', ['ICA_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath', [pwd '\output']);%exist twice because Matlab bug = .set not loading
 EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/capsedited.ced']);
 EEG=iclabel(EEG);
 noisethreshold = [0 0;0.9 1; 0.9 1; 0 0; 0 0; 0 0; 0 0]; % !Parameters for removing bad components
	EEG = pop_icflag(EEG, noisethreshold);
	% remove bad component(s)
	EEG = pop_subcomp( EEG );
	% save
	EEG = pop_saveset(EEG, 'filename',['ICs_ICA_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath', [pwd '\output']);
	
	% check bad channels again
	pop_rejchan(EEG)
    EEG = pop_rejchan(EEG, 'elec',[1:30] ,'threshold',5,'norm','on','measure','prob'); %parameters for automatic channel rejection
	
     fprintf('For next section: Remove *bad electrodes from brackets')
	%% artifact detection
	% exclude bad electrodes, comment which electrode(s) and restore after
	% participant done
	
	  frontals = [3:6];
	  electrodes=[1 2 7:30];%Po9 ch 32
	
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
	   
	EEG = pop_saveset( EEG, ['AR' nameerp] ,[pwd '\output']);
	    
	     % compute erp
	    ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' );
	    
	    % placing the electrodes for plot
	    % ERP = pop_erpchanoperator( ERP, placingelectrode );
	    
	    % load channel location information
	   % ERP = pop_erpchanedit( ERP, [currentDirectory 'capsedited.ced']);
	    
	    % Save the erp
	    ERP = pop_savemyerp(ERP, 'erpname',...
	        nameerp, 'filename', nameerp, 'filepath', [currentDirectory], 'Warning',...
	        'on');
	    
	    ERP = pop_summary_AR_erp_detection(ERP, [currentDirectory '\' nameerp(1:end-4) '.txt']);
	    
	    ERP = pop_summary_rejectfields(EEG);
	    
	%     plot the erp
	%     ERP = pop_ploterps( ERP, 1:2,  1:28 , 'Axsize', [ 0.14 0.1], 'BinNum', 'on', 'Blc', 'pre', 'ChLabel', 'on', 'FontSizeChan',...
	%         10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1, 'Maximize', 'on',...
	%         'Position', [ 103.667 29.625 106.833 31.9375], 'Style', 'Topo','Transparency',  0, 'xscale', [ -203.0 1195.0],...
	%         'YDir', 'reverse', 'yscale',[-15.0 15.0],'AutoYlim','off');
	%     
	    %export erp in.txt
	%     pop_export2text( ERP, exportname,  1, 'electrodes',...
	%         'on', 'precision',  4, 'time', 'on', 'timeunit',  0.001, 'transpose', 'on' ); 
    
    fprintf ('Participant H1 done')
	
% 	%%
% 	% Participant H2 same process
% 	
% 	j=2;
% 	
% 	%initializing variable
% 	nameerp = [name_temp(1:2) 'H' int2str(j) '.erp'];
% 	electrodes=[];
% 	
% 	% load 1HZ dataset
% 	EEG = pop_loadset('filename',['ChRm_1HZ_' name_temp(1:2) 'H' int2str(j) '.set'],'filepath',[pwd '\output']);
% 	EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/capsedited.ced']);
% 	
% 	% automatic channel rejection
% 	pop_rejchan(EEG)
% 	EEG = pop_rejchan(EEG, 'elec',[1:30] ,'threshold',5,'norm','on','measure','prob');
% 	
% 	fprintf('If *bad* channels exist, remove them from brackets in pop_runica')
%     
% 	%% run ICA 
%     % MANUAL MANIPULATION Chanind remove *bad* electrode from brackets to run ica e.g.[1:23 25:28] %24
% 	EEG = pop_runica(EEG, 'icatype', 'runica', 'chanind', [1:30], 'extended',1); % might need to change chanind (reject bad electrodes to run ica)
% 	EEG = pop_saveset( EEG, 'filename',['ICA_1HZ_' name_temp(1:2) 'H' int2str(j) '.set'],'filepath',[pwd '\output']);
% 	
% 	 
% 	    TMP.icawinv = EEG.icawinv;
% 	    TMP.icasphere = EEG.icasphere;
% 	    TMP.icaweights = EEG.icaweights;
% 	    TMP.icachansind = EEG.icachansind;
% 	 
% 		% apply to epoched dataset
% 		clear EEG;
% 	    
% 	    %CHANGE NAME
% 		EEG = pop_loadset('filename', ['ChRm_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath', [pwd '\output']);
% 		EEG.icawinv = TMP.icawinv;
% 		EEG.icasphere = TMP.icasphere;
% 		EEG.icaweights = TMP.icaweights;
% 		EEG.icachansind = TMP.icachansind;
% 		clear TMP;
% 		EEG = pop_saveset(EEG, 'filename',['ICA_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath');
%         
%         fprintf('For next section: Be careful when removing components. Optional manual check')
% %%
% %%%%OPTIONAL when 'reject component' window pops up, before rejecting need
% %to label components manually (PRECAUTION to avoid errors: to make sure
% %correct .set file loaded, and that correct components were labeled 90%
% %Muscle or Eye probability, other components are not removed.)
% 		EEG = pop_loadset('filename', ['ICA_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath', [pwd '\output']);
%         EEG = pop_loadset('filename', ['ICA_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath', [pwd '\output']);
% 		EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/capsedited.ced']);
% 		EEG=iclabel(EEG);
% 		noisethreshold = [0 0;0.9 1; 0.9 1; 0 0; 0 0; 0 0; 0 0]; % !Parameters to flag components
% 		EEG = pop_icflag(EEG, noisethreshold);
% 		% remove bad component(s)
% 		EEG = pop_subcomp( EEG );
% 		% save
% 		EEG = pop_saveset(EEG, 'filename',['ICs_ICA_0.1HZ_' name_temp(1:2) 'H' int2str(j) '.set'], 'filepath');
% 		
%         %%
% 		% check bad channels again
% 		pop_rejchan(EEG)
% 		
%         fprintf('For next section: Remove *bad electrodes from brackets')
% 		%% artifact detection
% 		% exclude bad electrodes, comment which electrode(s) and restore after
% 		% participant done
% 		
% 		  frontals = [3:6];
% 		  electrodes=[1 2 7:19 21:30];%20
% 		
% 		   % artifact detection
% 		    %peak to peak
% 		    EEG  = pop_artextval( EEG , 'Channel', electrodes, 'Flag',  1, 'Threshold', [ -75 75], 'Twindow',...
% 		        [ -204 1200] );
% 		    
% 		    %peak to peak for fp1 fp2 f7 f8
% 		    EEG  = pop_artextval( EEG , 'Channel', frontals, 'Flag',  1, 'Threshold', [ -100 100], 'Twindow',...
% 		        [ -204 1200] );
% 		        
% 		    %flat line
% 		    EEG  = pop_artflatline( EEG , 'Channel', electrodes, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow',...
% 		        [ -204 1200] );
% 		    
% 		    EEG  = pop_artflatline( EEG , 'Channel', frontals, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow',...
% 		        [ -204 1200] );
% 		   
% 		EEG = pop_saveset( EEG, ['AR' nameerp] ,[pwd '\output']);
% 		    
% 		     % compute erp
% 		    ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' )
% 		    
% 		    % Save the erp
% 		    ERP = pop_savemyerp(ERP, 'erpname',...
% 		        nameerp, 'filename', nameerp, 'filepath', [currentDirectory], 'Warning',...
% 		        'on');
% 		    
% 		    ERP = pop_summary_AR_erp_detection(ERP, [currentDirectory '\' nameerp(1:end-4) '.txt']);
% 		    
% 		    ERP = pop_summary_rejectfields(EEG);
% 		    
%             fprintf('DONE, GREAT JOB!! NOW SAVE YOUR LAST CREATED .SET files, .Erp & TXT. Recalculate elec if needed.'); 
% %Good job!! %Now save the last SET files, ERP files. 
% %Recalculate electrodes in EEGlab if needed and plot ERPs. 
