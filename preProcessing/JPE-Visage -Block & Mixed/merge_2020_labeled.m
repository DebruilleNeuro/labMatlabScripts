%function for PreprocessingVisage28.m
function EEG = merge_2020_labeled(set1, set2, set3, set4, save_name)

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',set1,'filepath',[pwd '\output']);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = pop_loadset('filename',set2,'filepath',[pwd '\output']);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = pop_loadset('filename',set3,'filepath',[pwd '\output']);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = pop_loadset('filename',set4,'filepath',[pwd '\output']);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'retrieve',1,'study',0); 

channel_indices = 1:8;

EEG.data(end+1:end+8,:) = ALLEEG(2).data(channel_indices,:);
EEG.nbchan = size(EEG.data,1);
if ~isempty(EEG.chanlocs)
 	EEG.chanlocs(end+1).labels = 'Pz';
 	EEG.chanlocs(end+1).labels = 'P4';
 	EEG.chanlocs(end+1).labels = 'P3';
 	EEG.chanlocs(end+1).labels = 'T6';
    EEG.chanlocs(end+1).labels = 'T5';
 	EEG.chanlocs(end+1).labels = 'T4';
    EEG.chanlocs(end+1).labels = 'T3';
    EEG.chanlocs(end+1).labels = 'A1A2';
end
EEG.saved = 'no';
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);

EEG.data(end+1:end+8,:) = ALLEEG(3).data(channel_indices,:);
EEG.nbchan = size(EEG.data,1);
if ~isempty(EEG.chanlocs)
 	EEG.chanlocs(end+1).labels = 'F4';
 	EEG.chanlocs(end+1).labels = 'F3';
 	EEG.chanlocs(end+1).labels = 'Ft8';
    EEG.chanlocs(end+1).labels = 'Ft7';
 	EEG.chanlocs(end+1).labels = 'Fc4';
    EEG.chanlocs(end+1).labels = 'Fc3';
 	EEG.chanlocs(end+1).labels = 'Fcz';
    EEG.chanlocs(end+1).labels = 'C4';
end
EEG.saved = 'no';
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);

EEG.data(end+1:end+8,:) = ALLEEG(4).data(channel_indices,:);
EEG.nbchan = size(EEG.data,1);
if ~isempty(EEG.chanlocs)
 	EEG.chanlocs(end+1).labels = 'C3';
 	EEG.chanlocs(end+1).labels = 'Tp8';
 	EEG.chanlocs(end+1).labels = 'Tp7';
    EEG.chanlocs(end+1).labels = 'Cp4';
 	EEG.chanlocs(end+1).labels = 'Cp3';
    EEG.chanlocs(end+1).labels = 'O2';
 	EEG.chanlocs(end+1).labels = 'O1';
    EEG.chanlocs(end+1).labels = 'Nez';
end
EEG.saved = 'no';
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);

EEG = pop_saveset(EEG, save_name , [pwd '\output']);
%eeglab redraw

end