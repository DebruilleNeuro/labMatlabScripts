clear
addpath(genpath('C:\Users\jeula\Documents\current subjects\eeglab2021.1'))

eeglab

currentDirectory = pwd;

    j=1
             
        [allEDF]=['04_S' int2str(j) '.EDF'];
        set1=[''.EDF'];
        set2=['04_S' int2str(j) 'o' '.EDF'];
        
        %Function to merge eegsets (modified with files in output folder)
        [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
        EEG = pop_loadset('filename',set1,'filepath',[pwd '/Sheila_unfiltered']);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        EEG1 = pop_loadset('filename',set2,'filepath',[pwd '/Sheila_original']);
        [ALLEEG, EEG1, CURRENTSET] = eeg_store( ALLEEG, EEG1, 0 );
   
        
%         no_trials=EEG.trials;
%         no_trials1=EEG1.trials;
%        
%         
%         Eventlist=EEG.EVENTLIST.trialsperbin;
%         Eventlist1=EEG1.EVENTLIST.trialsperbin;
%         
        
%         EEG = pop_saveset( EEG, 'filename',set1,'filepath',[pwd '/1HZ' int2str(j)]);
%         EEG1 = pop_saveset( EEG1, 'filename',set2,'filepath',[pwd '/1HZ' int2str(j)]);
%         EEG2 = pop_saveset( EEG2, 'filename',set3,'filepath',[pwd '/1HZ' int2str(j)]);
%         EEG3 = pop_saveset( EEG3, 'filename',set4,'filepath',[pwd '/1HZ' int2str(j)]);
%         EEG4 = pop_saveset( EEG4, 'filename',set5,'filepath',[pwd '/1HZ' int2str(j)]);
        
        
%         EEG = eeg_checkset(EEG,'makeur');
%         EEG1 = eeg_checkset(EEG1,'makeur');
%         EEG2 = eeg_checkset(EEG2,'makeur');
%         EEG3 = eeg_checkset(EEG3,'makeur');
%         EEG4 = eeg_checkset(EEG4,'makeur');
%         
%         clear ALLEEG
%         ALLEEG = [];
%         [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%         [ALLEEG, EEG1, CURRENTSET] = eeg_store( ALLEEG, EEG1, 0 );
%         [ALLEEG, EEG2, CURRENTSET] = eeg_store( ALLEEG, EEG2, 0 );
%         [ALLEEG, EEG3, CURRENTSET] = eeg_store( ALLEEG, EEG3, 0 );
%         [ALLEEG, EEG4, CURRENTSET] = eeg_store( ALLEEG, EEG4, 0 );
%         
        EEGMerged = [];
        EEGMerged = pop_mergeset(ALLEEG, [1:2]);
        
        appendname= [set1 'apd' '.erp'];
        EEGMerged = pop_saveset(EEG5, appendname, [pwd]);