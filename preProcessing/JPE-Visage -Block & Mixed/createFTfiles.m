
%% 
%%%%%%%%%%%%%%%%%%% creating the AVG files from the eeg.mat that conains
%%%%%%%%%%%%%%%%%%% the info about which trials to keep
%%%%
%%%
%% 
addpath(genpath('/Users\jeula\Documents\MATLAB\current subjects/fieldtrip-20190410'))    

% create a variable "code" including all S and D events and rejected trials
for i=1:numel(eeg.event)
code(i,1)=eeg.EVENTLIST.eventinfo(i).bini;
code(i,2)=eeg.EVENTLIST.eventinfo(i).flag; 
end

% recode the events so as to exclude rejected trials ==> 0
for i=1:numel(eeg.event)
    if code(i,1)==1 && code(i,2)==0
        ar_code(i,1)=1;
    elseif code(i,1)==2 && code(i,2)==0
        ar_code(i,1)=2;
    else
        ar_code(i,1)=0;
    end
end

% finding the row numbers corresponding to artefact-free S and D trials
SBD=find(ar_code==1);
DBD=find(ar_code==2);
INI=find(ar_code==3);
NII=find(ar_code==4);
NN=find(ar_code==5);

% extracting the SBD data trials
for i=1:length(SBD)
data_SBD(:,:,i)=eeg.data(:,:,SBD(i));
end
% extracting the DBD data trials
for i=1:length(DBD)
data_DBD(:,:,i)=eeg.data(:,:,DBD(i));
end
% extracting the INI data trials
for i=1:length(INI)
data_INI(:,:,i)=eeg.data(:,:,INI(i));
end
% extracting the NII data trials
for i=1:length(NII)
data_NII(:,:,i)=eeg.data(:,:,NII(i));
end
% extracting the NN data trials
for i=1:length(NN)
data_NN(:,:,i)=eeg.data(:,:,NN(i));
end

eeg_SBD=eeg;
eeg_DBD=eeg;
eeg_INI=eeg;
eeg_NII=eeg;
eeg_NN=eeg;

eeg_SBD.data=data_SBD;
eeg_DBD.data=data_DBD;
eeg_INI.data=data_INI;
eeg_NII.data=data_NII;
eeg_NN.data=data_NN;

eeg_SBD.trials=size(data_SBD,3);
eeg_DBD.trials=size(data_DBD,3);
eeg_INI.trials=size(data_INI,3);
eeg_NII.trials=size(data_NII,3);
eeg_NN.trials=size(data_NN,3);

% the following function will convert the eeg structure into a fieldtrip
% compatible format, and give it a new name (e.g. data).
data_SBD = eeglab2fieldtrip( eeg_SBD, 'preprocessing' );
data_DBD = eeglab2fieldtrip( eeg_DBD, 'preprocessing' );  
data_INI = eeglab2fieldtrip( eeg_INI, 'preprocessing' );
data_NII = eeglab2fieldtrip( eeg_NII, 'preprocessing' );  
data_NN = eeglab2fieldtrip( eeg_NII, 'preprocessing' ); 
% Since the file I have access to contains the data of two participants, I
% will create in the following 2 files, containing the data of partipant 1
clear eeg* code SBD DBD INI NII NN data_SBD data_DBD data_INI data_NII data_NN
% remove the field elec
% data_S=rmfield(data_SBD,'elec');
% data_D=rmfield(data_DBD,'elec');
% data_I=rmfield(data_INI,'elec');
% data_NI=rmfield(data_NII,'elec');
% data_N=rmfield(data_NN,'elec');

% data_SBD=rmfield(data_SBD,'elec');
% data_DBD=rmfield(data_DBD,'elec');
% data_INI=rmfield(data_INI,'elec');
% data_NII=rmfield(data_NII,'elec');
% data_NN=rmfield(data_NN,'elec');


%% Here once we created the two fieldtrip files, we are going to seperate the s1 and s2 
load('label.mat');

if j==1;

% participant 1 data, 
H1_SBD=data_S;
H1_SBD.label=label;
H1_DBD=data_D;
H1_DBD.label=label;
H1_INI=data_I;
H1_INI.label=label;
H1_NII=data_NI;
H1_NII.label=label;
H1_NN=data_N;
H1_NN.label=label;
% organize the data of S1
% s1_s
for kk=1:size(H1_SBD.trial,2)
    aa=H1_SBD.trial{kk}; % extract the first half of the data matrix from trial kk=1 till the end
    a=aa(1:35,:);
    b=a(3:8,:);
    c=a(10:17,:);
    d=a(19:26,:);
    e=a(28:35,:);
    f=[b ; c ; d ; e];
    H1_SBD.trial{kk}=f;
end
% organize the data of S1
% s1_d
for kk=1:size(H1_DBD.trial,2)
    aa=H1_DBD.trial{kk}; % extract the first half of the data matrix from trial kk=1 till the end
    a=aa(1:35,:);
    b=a(3:8,:);
    c=a(10:17,:);
    d=a(19:26,:);
    e=a(28:35,:);
    f=[b ; c ; d ; e];
    H1_DBD.trial{kk}=f;
end
%%%%%
for kk=1:size(H1_INI.trial,2)
    aa=H1_INI.trial{kk}; % extract the first half of the data matrix from trial kk=1 till the end
    a=aa(1:35,:);
    b=a(3:8,:);
    c=a(10:17,:);
    d=a(19:26,:);
    e=a(28:35,:);
    f=[b ; c ; d ; e];
    H1_INI.trial{kk}=f;
end
% organize the data of S1
% s1_d
for kk=1:size(H1_NII.trial,2)
    aa=H1_NII.trial{kk}; % extract the first half of the data matrix from trial kk=1 till the end
    a=aa(1:35,:);
    b=a(3:8,:);
    c=a(10:17,:);
    d=a(19:26,:);
    e=a(28:35,:);
    f=[b ; c ; d ; e];
    H1_NII.trial{kk}=f;
end

for kk=1:size(H1_NN.trial,2)
    aa=H1_NN.trial{kk}; % extract the first half of the data matrix from trial kk=1 till the end
    a=aa(1:35,:);
    b=a(3:8,:);
    c=a(10:17,:);
    d=a(19:26,:);
    e=a(28:35,:);
    f=[b ; c ; d ; e];
    H1_NN.trial{kk}=f;
end
%%%

elseif j==2;
% participant 2 data 
H2_SBD=data_SBD;
H2_SBD.label=label;
H2_DBD=data_DBD;
H2_DBD.label=label;
H2_INI=data_INI;
H2_INI.label=label;
H2_NII=data_NII;
H2_NII.label=label;
H2_NN=data_NN;
H2_NN.label=label;
% organize the data of S2
% s2_s

for kk=1:size(H2_SBD.trial,2)
aa=H2_SBD.trial{kk}; 
a=aa(37:71,:); % extract the second half of the data matrix from trial kk=1 till the end
b=a(3:8,:);
c=a(10:17,:);
d=a(19:26,:);
e=a(28:35,:);
f=[b ; c ; d ; e];
H2_SBD.trial{kk}=f;
end                
               
for kk=1:size(H2_DBD.trial,2)
aa=H2_DBD.trial{kk}; 
a=aa(37:71,:); % extract the second half of the data matrix from trial kk=1 till the end
b=a(3:8,:);
c=a(10:17,:);
d=a(19:26,:);
e=a(28:35,:);
f=[b ; c ; d ; e];
H2_DBD.trial{kk}=f;
end

for kk=1:size(H2_INI.trial,2)
aa=H2_INI.trial{kk}; 
a=aa(37:71,:); % extract the second half of the data matrix from trial kk=1 till the end
b=a(3:8,:);
c=a(10:17,:);
d=a(19:26,:);
e=a(28:35,:);
f=[b ; c ; d ; e];
H2_INI.trial{kk}=f;
end

for kk=1:size(H2_NII.trial,2)
aa=H2_NII.trial{kk}; 
a=aa(37:71,:); % extract the second half of the data matrix from trial kk=1 till the end
b=a(3:8,:);
c=a(10:17,:);
d=a(19:26,:);
e=a(28:35,:);
f=[b ; c ; d ; e];
H2_NII.trial{kk}=f;
end

for kk=1:size(H2_NN.trial,2)
aa=H2_NN.trial{kk}; 
a=aa(37:71,:); % extract the second half of the data matrix from trial kk=1 till the end
b=a(3:8,:);
c=a(10:17,:);
d=a(19:26,:);
e=a(28:35,:);
f=[b ; c ; d ; e];
H2_NN.trial{kk}=f;
end
end
clear data_DBD data_SBD data_INI data_NII data_NN a aa b c d e f i

% create the names to save the files           

ii='AR4'; % ii corresponds to the year month
jj='M';% jj corresponds to the day and mix or block

% averaging trials and keeping all trials
cfg=[];
cfg.keeptrials='yes';
[s1_s_avg] = ft_timelockanalysis(cfg, s1_s)

cfg=[];
cfg.keeptrials='yes';
[s1_d_avg] = ft_timelockanalysis(cfg, s1_d)

cfg=[];
cfg.keeptrials='yes';
[s2_s_avg] = ft_timelockanalysis(cfg, s2_s)

cfg=[];
cfg.keeptrials='yes';
[s2_d_avg] = ft_timelockanalysis(cfg, s2_d)

clear s1_s s2_s s1_d s2_d

name1= strcat(ii,jj,'H1', '_SameAVG');
name2= strcat(ii,jj,'H1', '_DiffAVG');
name3= strcat(ii,jj,'H2', '_SameAVG');
name4= strcat(ii,jj,'H2', '_DiffAVG');
      

eval([name1 '=s1_s_avg;'])
eval([name2 '=s1_d_avg;'])
eval([name3 '=s2_s_avg;'])
eval([name4 '=s2_d_avg;'])
eval(['save ' name1 ' ' name1])
eval(['save ' name2 ' ' name2])
eval(['save ' name3 ' ' name3])
eval(['save ' name4 ' ' name4])

clear 
fprintf(':) done :) Remember to only keep the AVG files (H1 or H2) that correspond to the SET file that you are currently running.\n');