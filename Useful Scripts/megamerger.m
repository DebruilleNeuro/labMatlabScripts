clear
addpath(genpath('C:\Users\jeula\Documents\current subjects\eeglab2021.1'))

eeglab

currentDirectory = pwd;

for j=1
    
    if j==1
        searchFilter1hz = '*.set';
        %currentDirectory01hz = [pwd '/01HZ'];
        FileDirectory1hz = [pwd '/1HZ1'];
        set1FileDirectory = fullfile(FileDirectory1hz);
        addpath( set1FileDirectory );
        searchString1hz = [set1FileDirectory, '/', searchFilter1hz];
        Filelist1hz = dir(searchString1hz);
        N = length(Filelist1hz) ;
        EEGSET = cell(1,N) ;
        
    elseif j==2
        searchFilter1hz = '*.set';
        %currentDirectory01hz = [pwd '/01HZ'];
        FileDirectory1hz = [pwd '/1HZ2'];
        set1FileDirectory = fullfile(FileDirectory1hz);
        addpath( set1FileDirectory );
        searchString1hz = [set1FileDirectory, '/', searchFilter1hz];
        Filelist1hz = dir(searchString1hz);
        N = length(Filelist1hz) ;
        EEGSET = cell(1,N) ;
    end
    
    if j==1
        searchFilter01hz = '*.set';
        
        FileDirectory01hz = [pwd '/01HZ1'];
        set01FileDirectory = fullfile(FileDirectory01hz);
        addpath( set01FileDirectory );
        searchString01hz = [set01FileDirectory, '/', searchFilter01hz];
        Filelist01hz = dir(searchString01hz);
        N = length(Filelist01hz) ;
        EEGSET = cell(1,N) ;
        
    elseif j==2
        searchFilter01hz = '*.set';
        %currentDirectory01hz = [pwd '/01HZ'];
        FileDirectory01hz = [pwd '/01HZ2' ];
        set01FileDirectory = fullfile(FileDirectory01hz);
        addpath( set01FileDirectory );
        searchString01hz = [set01FileDirectory, '/', searchFilter01hz];
        Filelist01hz = dir(searchString01hz);
        N = length(Filelist01hz) ;
        EEGSET = cell(1,N) ;
    end
    
    for i = 1:N
        %
        
        name_temp = Filelist1hz(i).name;
        name_temp2 = Filelist01hz(i).name; %7 10
        
        
        
        set1=['1HZ_C_' name_temp(7:8) '_S' int2str(j) '.set'];
        set2=['1HZ_D_' name_temp(7:8) '_S' int2str(j) '.set'];
        set3=['1HZ_A_' name_temp(7:8) '_S' int2str(j) '.set'];
        
        
        %Function to merge eegsets (modified with files in output folder)
        [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
        EEG = pop_loadset('filename',set1,'filepath',[pwd '/1HZ' int2str(j)]);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        EEG1 = pop_loadset('filename',set2,'filepath',[pwd '/1HZ' int2str(j)]);
        [ALLEEG, EEG1, CURRENTSET] = eeg_store( ALLEEG, EEG1, 0 );
        EEG2 = pop_loadset('filename',set3,'filepath',[pwd '/1HZ' int2str(j)]);
        [ALLEEG, EEG2, CURRENTSET] = eeg_store( ALLEEG, EEG2, 0 );
        
        no_trials=EEG.trials;
        no_trials1=EEG1.trials;
        no_trials2=EEG2.trials;
        
        EEG = eeg_checkset(EEG,'makeur');
        EEG1 = eeg_checkset(EEG1,'makeur');
        EEG2 = eeg_checkset(EEG2,'makeur');
        
        clear ALLEEG
        ALLEEG = [];
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        [ALLEEG, EEG1, CURRENTSET] = eeg_store( ALLEEG, EEG1, 0 );
        [ALLEEG, EEG2, CURRENTSET] = eeg_store( ALLEEG, EEG2, 0 );
        
        EEG = pop_mergeset(ALLEEG, [1:3]);
        eeg.EVENTLIST.eventinfo = [EEG.EVENTLIST.eventinfo, EEG1.EVENTLIST.eventinfo, EEG2.EVENTLIST.eventinfo]
        
        appendname1= ['1HZ_' name_temp(7:8) '_S' int2str(j) 'apd' '.set'];
        EEG = pop_saveset(EEG, appendname1, [pwd]);
        
        
        set1=['0.1HZ_C_' name_temp2(9:10) '_S' int2str(j) '.set'];
        set2=['0.1HZ_D_' name_temp2(9:10) '_S' int2str(j) '.set'];
        set3=['0.1HZ_A_' name_temp2(9:10) '_S' int2str(j) '.set'];
        
        
        %Function to merge eegsets (modified with files in output folder)
        [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
        EEG = pop_loadset('filename',set1,'filepath',[pwd '/01HZ' int2str(j)]);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        EEG1 = pop_loadset('filename',set2,'filepath',[pwd '/01HZ' int2str(j)]);
        [ALLEEG, EEG1, CURRENTSET] = eeg_store( ALLEEG, EEG1, 0 );
        EEG2 = pop_loadset('filename',set3,'filepath',[pwd '/01HZ' int2str(j)]);
        [ALLEEG, EEG2, CURRENTSET] = eeg_store( ALLEEG, EEG2, 0 );
        
        no_trials=EEG.trials;
        no_trials1=EEG1.trials;
        no_trials2=EEG2.trials;
        
        EEG = eeg_checkset(EEG,'makeur');
        EEG1 = eeg_checkset(EEG1,'makeur');
        EEG2 = eeg_checkset(EEG2,'makeur');
        
        clear ALLEEG
        ALLEEG = [];
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        [ALLEEG, EEG1, CURRENTSET] = eeg_store( ALLEEG, EEG1, 0 );
        [ALLEEG, EEG2, CURRENTSET] = eeg_store( ALLEEG, EEG2, 0 );
        
        EEG = pop_mergeset(ALLEEG, [1:3]);
        eeg.EVENTLIST.eventinfo = [EEG.EVENTLIST.eventinfo, EEG1.EVENTLIST.eventinfo, EEG2.EVENTLIST.eventinfo]
        
        appendname= ['01HZ_' name_temp2(9:10) '_S' int2str(j) 'apd' '.set'];
        EEG = pop_saveset(EEG, appendname, [pwd]);
        
        if N==19;
        break 
        end
    end
    
end

%%

for j=2
    
    if j==1
        searchFilter1hz = '*.set';
        %currentDirectory01hz = [pwd '/01HZ'];
        FileDirectory1hz = [pwd '/1HZ1'];
        set1FileDirectory = fullfile(FileDirectory1hz);
        addpath( set1FileDirectory );
        searchString1hz = [set1FileDirectory, '/', searchFilter1hz];
        Filelist1hz = dir(searchString1hz);
        N = length(Filelist1hz) ;
        EEGSET = cell(1,N) ;
        
    elseif j==2
        searchFilter1hz = '*.set';
        %currentDirectory01hz = [pwd '/01HZ'];
        FileDirectory1hz = [pwd '/1HZ2'];
        set1FileDirectory = fullfile(FileDirectory1hz);
        addpath( set1FileDirectory );
        searchString1hz = [set1FileDirectory, '/', searchFilter1hz];
        Filelist1hz = dir(searchString1hz);
        N = length(Filelist1hz) ;
        EEGSET = cell(1,N) ;
    end
    
    if j==1
        searchFilter01hz = '*.set';
        
        FileDirectory01hz = [pwd '/01HZ1'];
        set01FileDirectory = fullfile(FileDirectory01hz);
        addpath( set01FileDirectory );
        searchString01hz = [set01FileDirectory, '/', searchFilter01hz];
        Filelist01hz = dir(searchString01hz);
        N = length(Filelist01hz) ;
        EEGSET = cell(1,N) ;
        
    elseif j==2
        searchFilter01hz = '*.set';
        %currentDirectory01hz = [pwd '/01HZ'];
        FileDirectory01hz = [pwd '/01HZ2' ];
        set01FileDirectory = fullfile(FileDirectory01hz);
        addpath( set01FileDirectory );
        searchString01hz = [set01FileDirectory, '/', searchFilter01hz];
        Filelist01hz = dir(searchString01hz);
        N = length(Filelist01hz) ;
        EEGSET = cell(1,N) ;
    end
    
    for i = 1:N
        %
        
        name_temp = Filelist1hz(i).name;
        name_temp2 = Filelist01hz(i).name; %7 10
        
        
        
        set1=['1HZ_C_' name_temp(7:8) '_S' int2str(j) '.set'];
        set2=['1HZ_D_' name_temp(7:8) '_S' int2str(j) '.set'];
        set3=['1HZ_A_' name_temp(7:8) '_S' int2str(j) '.set'];
        
        
        %Function to merge eegsets (modified with files in output folder)
        [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
        EEG = pop_loadset('filename',set1,'filepath',[pwd '/1HZ' int2str(j)]);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        EEG1 = pop_loadset('filename',set2,'filepath',[pwd '/1HZ' int2str(j)]);
        [ALLEEG, EEG1, CURRENTSET] = eeg_store( ALLEEG, EEG1, 0 );
        EEG2 = pop_loadset('filename',set3,'filepath',[pwd '/1HZ' int2str(j)]);
        [ALLEEG, EEG2, CURRENTSET] = eeg_store( ALLEEG, EEG2, 0 );
        
        no_trials=EEG.trials;
        no_trials1=EEG1.trials;
        no_trials2=EEG2.trials;
        
        EEG = eeg_checkset(EEG,'makeur');
        EEG1 = eeg_checkset(EEG1,'makeur');
        EEG2 = eeg_checkset(EEG2,'makeur');
        
        clear ALLEEG
        ALLEEG = [];
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        [ALLEEG, EEG1, CURRENTSET] = eeg_store( ALLEEG, EEG1, 0 );
        [ALLEEG, EEG2, CURRENTSET] = eeg_store( ALLEEG, EEG2, 0 );
        
        EEG = pop_mergeset(ALLEEG, [1:3]);
        eeg.EVENTLIST.eventinfo = [EEG.EVENTLIST.eventinfo, EEG1.EVENTLIST.eventinfo, EEG2.EVENTLIST.eventinfo]
        
        appendname1= ['1HZ_' name_temp(7:8) '_S' int2str(j) 'apd' '.set'];
        EEG = pop_saveset(EEG, appendname1, [pwd]);
        
        
        set1=['0.1HZ_C_' name_temp2(9:10) '_S' int2str(j) '.set'];
        set2=['0.1HZ_D_' name_temp2(9:10) '_S' int2str(j) '.set'];
        set3=['0.1HZ_A_' name_temp2(9:10) '_S' int2str(j) '.set'];
        
        
        %Function to merge eegsets (modified with files in output folder)
        [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
        EEG = pop_loadset('filename',set1,'filepath',[pwd '/01HZ' int2str(j)]);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        EEG1 = pop_loadset('filename',set2,'filepath',[pwd '/01HZ' int2str(j)]);
        [ALLEEG, EEG1, CURRENTSET] = eeg_store( ALLEEG, EEG1, 0 );
        EEG2 = pop_loadset('filename',set3,'filepath',[pwd '/01HZ' int2str(j)]);
        [ALLEEG, EEG2, CURRENTSET] = eeg_store( ALLEEG, EEG2, 0 );
        
        no_trials=EEG.trials;
        no_trials1=EEG1.trials;
        no_trials2=EEG2.trials;
        
        EEG = eeg_checkset(EEG,'makeur');
        EEG1 = eeg_checkset(EEG1,'makeur');
        EEG2 = eeg_checkset(EEG2,'makeur');
        
        clear ALLEEG
        ALLEEG = [];
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        [ALLEEG, EEG1, CURRENTSET] = eeg_store( ALLEEG, EEG1, 0 );
        [ALLEEG, EEG2, CURRENTSET] = eeg_store( ALLEEG, EEG2, 0 );
        
        EEG = pop_mergeset(ALLEEG, [1:3]);
        eeg.EVENTLIST.eventinfo = [EEG.EVENTLIST.eventinfo, EEG1.EVENTLIST.eventinfo, EEG2.EVENTLIST.eventinfo]
        
        appendname= ['01HZ_' name_temp2(9:10) '_S' int2str(j) 'apd' '.set'];
        EEG = pop_saveset(EEG, appendname, [pwd]);
        
        if N==19;
        break 
        end
    end
    
end
