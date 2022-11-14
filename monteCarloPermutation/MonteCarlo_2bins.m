%Exctracts the trials that were accepted after artifact rejection and
%homogenize the conditions as to have the same number of trials in all
%conditions to do the Monte-Carlo.
%not most up to date montecarlo script
%
%This script is for a 5 conditions JPE experiment, but can be modified to
%fit any number of conditions.
%define the filename
filename='04_MH1.set';%load manually if does not work and run from line 19 redraw
currentPath = pwd; %defines currentPath as current directory
path2eeglab ='C:\Users\jeula\Documents\current subjects\eeglab2021.1' %Here, put your OWN path to EEGLAB
path2fieldtrip ='C:\Users\jeula\Documents\current subjects\fieldtrip\fieldtrip-20190410' %Here, put your OWN path to FIELDTRIP 
%
% Add eeglab path to matlab path
addpath(genpath(path2eeglab)) %adds EEGLAB to path


% eeglab command to open the GUI
[ALLEEG eeg CURRENTSET ALLCOM] = eeglab;

%load the data set in variable called 'name'
eeg = pop_loadset('filename',filename,'filepath',currentPath); %filename and filepath defined above (looks for the filename you gave in the current folder you're in)

%eegcheckset, check the consistency of the fields of an EEG dataset
eeg = eeg_checkset( eeg );
eeglab redraw;

%ARTIFACT REJECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IF YOUR DATA DIDNT GO THROUGH ARTIFACT REJECTION PASTE ARTIFACT REJECTION
%SCRIPT HERE
%%
close (eeglab)%close eeglab GUI

%remove eeglab path from matlab path
%We don't need eeglab anymore and need to remove it from path because
%we want to use fieldtrip now and eeglab and fieldtrip conflict
rmpath(genpath(path2eeglab))
%
addpath(genpath(path2fieldtrip)) %add fieldtrip to path

%filename becomes the characters 1 to -4 (without last 4 characters) of eeg.filename (variable eeg, subvariable filename,this will remove the extension .set from name)
filename = eeg.filename((1:end-4) 

% create a variable "code" with column 1 = list of events using bin codes
% (e.g trial 1 was bin1, trial 2 was bin 2 etc) and column 2 identifies if
% trial was rejected or not
for i=1:numel(eeg.event)
    code(i,1)=eeg.EVENTLIST.eventinfo(i).bini; %bins
    code(i,2)=eeg.EVENTLIST.eventinfo(i).flag; %trial flagged or not
end

%create list of events per condition (number 1:5 in bini) with only
%accepted trials (flag=0 not 1). %change here according to your conditions
for i=1:numel(eeg.event)
    if code(i,1)==1 && code(i,2)==0
        ar_code(i,1)=1; %bin1 condition SBD
    elseif code(i,1)==2 && code(i,2)==0
        ar_code(i,1)=2; %bin2 condition DBD
    else
        ar_code(i,1)=0;
    end
end

% finding the row numbers corresponding to artifact-free trials for each
% condition
%for i = 1: numel(conditions)
SBD=find(ar_code==1);
DBD=find(ar_code==2);

%create array with list of trials for each condition (e.g trials n°3, n°5, n°10 belong to condition SBD) %change here according to your conditions
conditions = {SBD DBD}

%Rejects trials so that each condition has the same amount of trials

%BETWEEN ALL CONDITIONS
trials_array = [numel(DBD),numel(SBD),numel(INI),numel(NII),numel(NN)]
min_val = min(min(trials_array))

%if the minimum amount of trials is less than 35 trials, it means that either there aren't enough trials to analyze (<35) or the minimum 
%is 0 meaning that there either is a pb with the code or a condition is absent (maybe you only hve 4 conditions and try to use this script)
if min_val<35; 
   msg = 'condition(s) may be missing or not enough trials may be present.';
    error(msg)
end

%This loop evens out the trials for each condition. If 135 trials in SBD
%condition and 140 in DBD condition, it will remove 5 trials from DBD
%array.
for i = 1:numel(conditions)
    if numel(conditions{1,i})~=min_val
        gap= numel(conditions{1,i}) - min_val
        for n=1:abs(gap)
            Index = randi(length(conditions{1,i}), 1)
            conditions{1,i}(Index,:) = []
        end
    end
end

%creates a structure with each cell named after one of te conditions and containing the root eeg structure 
eegperbin=struct('SBD', eeg, 'DBD', eeg)
fieldNames = fieldnames(eegperbin);
%inititates cfg	
%"cfg" is the Fieldtrip configuration structure, which contains all	
% details for the dataset filename, trials and the preprocessing options.	
% similar to the EEG structure for eeglab
cfg=[];

for loopBins= 1:numel(fieldNames)
    
    for n=1:length(conditions{1,loopBins});
        currenttrials= conditions{1,loopBins};
        currentdata(:,:,n) = eeg.data(:,:,currenttrials(n));
        eegperbin.(fieldNames{loopBins}).data = currentdata
    end
    
    eegperbin.(fieldNames{loopBins}).trials=size(eegperbin.(fieldNames{loopBins}).data,3);
    eegperbin.(fieldNames{loopBins}).data = eeglab2fieldtrip( eegperbin.(fieldNames{loopBins}), 'preprocessing' );
    [monteCarloFiles.(fieldNames{loopBins})] = eegperbin.(fieldNames{loopBins}).data
    cfg.keeptrials='yes';
    %computes the timelocked average ERP and computes the covariance matrix
    [monteCarloFiles.(fieldNames{loopBins})] = ft_timelockanalysis(cfg, monteCarloFiles.(fieldNames{loopBins}))
    %adds filename to monteCarloFiles struct
    [monteCarloFiles.(fieldNames{loopBins}).filename] = eegperbin.(fieldNames{loopBins}).filename
    [monteCarloFiles.(fieldNames{loopBins}).filebin] = (fieldNames{loopBins});
end

%clearvars -except monteCarloFiles
fprintf(':) done :)\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath(fieldtripPath))
%automatic bootstrap 5 conditions
binPairing = {'SBD';'DBD'}
tableArray =cell(1,numel(binPairing)/2);
whichColumn=0 %variable  to index column number in cell array Table
latency = [0.75, 0.15; 0.2, 0.30; 0.35, 0.55; 0.65, 0.95];

for loopBins=1:2:numel(binPairing) %loop to load all files within the binPairing data strucAR200721MH1_DiffAVGture, loop goes every 2 steps
    whichColumn=whichColumn+1
    
    bin1=monteCarloFiles.(binPairing{loopBins});%create files 1 as structure containing structure of DIFFAVG in one field
    bin2=monteCarloFiles.(binPairing{loopBins+1});%create files 1 as structure containing structure of DIFFAVG in one field
    
    cfg = []; %initiates fieldtrip structure
    
    for index = 1: numel(latency)/2; %loops for each latency 
        cfg.channel = bin1.label;
        cfg.latency       = [latency(index,1),latency(index,2)]
        cfg.avgovertime = 'yes'; %or 'no'                    (default = 'no')
        cfg.method = 'montecarlo';       % use the Monte Carlo Method to calculate the significance probability
        cfg.statistic = 'ft_statfun_depsamplesT'; % use the dependent samples T-statistic
        cfg.tail = 0;                    % -1, 1 or 0 (default = 0); one-sided or two-sided test
        cfg.alpha = 0.05;
        cfg.correcttail = 'alpha';
        cfg.numrandomization = 1000;      % number of draws from the permutation distribution
        cfg.computecritval = 'yes';
        %cfg.correctm = 'fdr';
        
        Ntrials = size(bin1.trial,1); % number of trials
        cfg.design(1,1:2*Ntrials)  = [ones(1,Ntrials) 2*ones(1,Ntrials)];
        cfg.design(2,1:2*Ntrials)  = [1:Ntrials 1:Ntrials];
         cfg.ivar                = 1; % the 1st row in cfg.design contains the independent variable
        cfg.uvar                = 2; % the 2nd row in cfg.design contains the subject number
        cfg.ivar  = 1;                   % number or list with indices indicating the independent variable(s)
        
        [stat] = ft_timelockstatistics(cfg, bin1, bin2); %computes significance probabilities and/or critical values of a parametric statistical test or a non-parametric permutation test.
        
        binPair = char([bin1.filebin,'_' bin2.filebin]); %will be title of each column in table contains info about which conditions were paired
        statcell=stat.prob; %stat cell is a array containing stat.prob at the iteration i or v
        disp(statcell(:,:));
        
        for k=1:length(statcell) %for loop to ietrate through statcell (channels)
            tableArray(k,whichColumn)= {statcell(k,:)}; %cell coordonate k,V = statcell coordonate k,:
            binPairCell(1,whichColumn)= {binPair}; %cell coordonate 1,V = code of participants but in a cell type
            
            Texcel=cell2table(tableArray); %convert cell array T to table Tfinal
            Texcel.Properties.VariableNames = binPairCell; %use B charactere array to set variable names
            filename='bootstrapauto.xlsx'
            
            whichsheet = {'75 150', '200 350', '350 550', '650 950'};
            sheetchar = char(whichsheet(index))
            writetable(Texcel,filename,'Sheet', sheetchar);
            %sheetNumber = 1;
            %range = 'a1';
            %xlswrite('name.xls', dwname, sheetNumber, range);
            
        end
        
    end
    
end