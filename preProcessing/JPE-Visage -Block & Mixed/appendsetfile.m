% Add eeglab path
addpath(genpath('C:\Users\jeula\Documents\current subjects/eeglab2021.1')) 
currentDirectory = pwd;
% recombination of split Set files
% define the files' labels with respect to cycles (subj nb)
name='1HZ_A_02_S1.set';
name1='1HZ_c_02_S1.set';
name2='1HZ_D_02_S1.set';
%load manually if does not work and run from line 19 redraw
currentPath = pwd;

[ALLEEG EEG EEG1 CURRENTSET ALLCOM] = eeglab;                        % eeglab command to open the GUI
EEG = pop_loadset('filename',name,'filepath',currentPath); 
EEG1 = pop_loadset('filename',name1,'filepath',currentPath); 
EEG2 = pop_loadset('filename',name2,'filepath',currentPath);

no_trials=EEG.trials;
no_trials1=EEG1.trials;
no_trials2=EEG2.trials;

%A=[]
%B=[]
%j=1;
%for k=1:no_trials
    %if(EEG.epoch(k).eventflag==1)
       %A(j)=k;
       %j=j+1;
    %end
%end
    
     %EEG= pop_rejepoch( EEG,A,0);
    
%i=1;
%for m=1:no_trials2
    %if(EEG1.epoch(m).eventflag==1)
       %B(i)=m;
       %i=i+1;
    %end
%end
    
     %EEG1= pop_rejepoch( EEG1,B,0);

     
    

EEG = pop_saveset( EEG, [name],[currentDirectory]);
EEG1 = pop_saveset( EEG1, [name1],[currentDirectory]);
EEG2 = pop_saveset( EEG2, [name2],[currentDirectory]);

  
EEG = eeg_checkset(EEG,'makeur')
EEG1 = eeg_checkset(EEG1,'makeur')
EEG2 = eeg_checkset(EEG2,'makeur')

eeg = pop_mergeset(EEG, EEG1)


eeg.EVENTLIST.eventinfo= [EEG.EVENTLIST.eventinfo, EEG1.EVENTLIST.eventinfo]
%eeg.reject.rejmanual=[EEG.reject.rejmanual EEG1.reject.rejmanual]
%eeg.reject.rejmanualE=[EEG.reject.rejmanualE EEG1.reject.rejmanualE]

eeg = pop_saveset( eeg, ['AR' name],[currentDirectory]);
%%
close (eeglab) 
clear all
% compute erp
addpath(genpath('D:\document\master\matlab données\curent subject\visage2020\eeglab14_1_1b')) 
currentDirectory = pwd;
currentPath = pwd;

[ALLEEG EEG EEG1 EEG2 CURRENTSET ALLCOM] = eeglab;  

name=input('Which set file? (you have to write between '' with the extension .set)');
nameerp=name(1:end-4);
eeg=  pop_loadset('filename',name,'filepath',currentPath); 
EEG=eeg;

ERP = pop_averager( EEG , 'Criterion', 'good',  'ExcludeBoundary', 'on' );
name_temp=name
if name_temp(12)=='1'
       
    placingelectrode = {'nch1 = ch3 label Fp2',  'nch2 = ch4 label Fp1',  'nch3 = ch5 label F8',  'nch4 = ch6 label F7',...
                        'nch5 = ch7 label Fz',  'nch6 = ch8 label Cz',  'nch7 = ch10 label Pz',  'nch8 = ch11 label P4',  'nch9 = ch12 label P3',  'nch10 = ch13 label T6',...
                        'nch11 = ch14 label T5',  'nch12 = ch15 label T4',  'nch13 = ch16 label T3',  'nch14 = ch19 label F4',  'nch15 = ch20 label F3',...
                        'nch16 = ch21 label Ft8',  'nch17 = ch22 label Ft7',  'nch18 = ch23 label Fc4',  'nch19 = ch24 label Fc3',  'nch20 = ch25 label Fcz',  'nch21 = ch26 label C4',...
                        'nch22 = ch28 label C3',  'nch23 = ch29 label Tp8',  'nch24 = ch30 label Tp7',  'nch25 = ch31 label Cp4',  'nch26 = ch32 label Cp3',...
                        'nch27 = ch33 label O2',  'nch28 = ch34 label O1'};
elseif name_temp(12)=='2'
           placingelectrode = {'nch1 = ch39 label Fp2',  'nch2 = ch40 label Fp1',  'nch3 = ch41 label F8',  'nch4 = ch42 label F7',...
                        'nch5 = ch43 label Fz',  'nch6 = ch44 label Cz',  'nch7 = ch46 label Pz',  'nch8 = ch47 label P4',  'nch9 = ch48 label P3',  'nch10 = ch49 label T6',...
                        'nch11 = ch50 label T5',  'nch12 = ch51 label T4',  'nch13 = ch52 label T3',  'nch14 = ch55 label F4',  'nch15 = ch56 label F3',...
                        'nch16 = ch57 label Ft8',  'nch17 = ch58 label Ft7',  'nch18 = ch59 label Fc4',  'nch19 = ch60 label Fc3',  'nch20 = ch61 label Fcz',...
                        'nch21 = ch62 label C4',  'nch22 = ch64 label C3',  'nch23 = ch65 label Tp8',  'nch24 = ch66 label Tp7',  'nch25 = ch67 label Cp4',  'nch26 = ch68 label Cp3',...
                        'nch27 = ch69 label O2',  'nch28 = ch70 label O1'};
    
end
ERP = pop_erpchanoperator( ERP, placingelectrode );



ERP = pop_savemyerp(ERP, 'erpname', nameerp, 'filename', [nameerp '.erp'], 'filepath', [currentDirectory], 'Warning',...
        'on');
