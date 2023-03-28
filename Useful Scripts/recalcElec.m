%Recalc electrodes
clear
path2eeglab ='/Users\jeula\Documents\current subjects\eeglab2021.1' %Here, put your OWN path to EEGLAB
%rmpath(genpath(path2eeglab)
%addpath(genpath('C:\Users\jeula\Documents\current subjects\eeglab2021.1'))
addpath(genpath(path2eeglab))

eeglab

erpset='21BH1H2_H1.erp' %change name
elec='f3' %change elec
j=1
n=1

[ERP ALLERP] = pop_loaderp( 'filename', {erpset}, 'filepath',...
    'C:\Users\jeula\Documents\current subjects\MATFLO308\' );

%%%change formula
ERP = pop_erpchanoperator( ERP, {'ch15 =(ch19+(1/2)*ch4+(1/2)*ch5)/2'} , 'ErrorMsg', 'popup', 'KeepLocations',  1, 'Warning', 'on' );

newerpname= [erpset(1:end-4),elec, '.erp']
newfilename = [erpset(1:end-4),elec]
ERP = pop_savemyerp(ERP, 'erpname', newfilename, 'filename', newerpname, 'filepath',...
 'C:\Users\jeula\Documents\current subjects\MATFLO308\', 'Warning', 'on');

% j=str2num(erpset(7))
% n=str2num(erpset(9))

ERP = pop_loaderp ('filename', newerpname)
if n==2;
if j==1;
 ERP = pop_ploterps( ERP, [1 2 3],  1:28 , 'AutoYlim', 'on', 'Axsize', [ 0.13 0.15], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 6 5], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' , 'b-'}, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 80.3 6.76923 106.9 31.9231], 'Style', 'Topo', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale', [ -203.0 1195.0   -200:200:1000 ],...
 'YDir', 'reverse' );
elseif j==2;
   ERP = pop_ploterps( ERP, [1 2 3],  1:28 , 'AutoYlim', 'on', 'Axsize', [ 0.13 0.15], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 6 5], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'r-' , 'k-' , 'b-' }, 'LineWidth',  1,...
 'Maximize', 'on', 'Position', [ 53.9 4.34615 106.9 31.9231], 'Style', 'Topo', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -203.0 996.0   -200:200:800 ], 'YDir', 'reverse' );
end

elseif n==1;
    if j==1;
 ERP = pop_ploterps( ERP, [1 2],  1:28 , 'AutoYlim', 'on', 'Axsize', [ 0.13 0.15], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 6 5], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'r-' ,'k-'}, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 80.3 6.76923 106.9 31.9231], 'Style', 'Topo', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale', [ -203.0 1195.0   -200:200:1000 ],...
 'YDir', 'reverse' );
elseif j==2
   ERP = pop_ploterps( ERP, [1 2],  1:28 , 'AutoYlim', 'on', 'Axsize', [ 0.13 0.15], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 6 5], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'r-' , 'k-' , 'b-' }, 'LineWidth',  1,...
 'Maximize', 'on', 'Position', [ 53.9 4.34615 106.9 31.9231], 'Style', 'Topo', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -203.0 996.0   -200:200:800 ], 'YDir', 'reverse' );
 end
end
clear
% FC3: ch19 =((1/2)*ch17+ch15+(1/2)*ch20+ch22)/3
% FC4: ch18 =((1/2)*ch20+(1/2)*ch16+ch14+ch21)/3
% 
% T3: ch13 =(ch17+ch24)/2 T3=(FT7+TP7)/2
% T4: ch12 =(ch16+ch23)/2
% 
% CP3: ch26 =(ch22+ch9)/2
% Cp4: ch25 =(ch21+ch8)/2
% 
% TP7: ch24 =(ch13+ch11)/2  TP7=(T3+T5)/2
% Tp8: ch23 =(ch12+ch10)/2
% 
% FT7: ch17 =(ch4+ch13)/2  FT7=(F7+T3)/2
% FT8: ch16 =(ch3+ch12)/2
% 
% F4: ch14 =(ch18+(1/2)*ch5+(1/2)*ch3)/2
% F3: ch15 =(ch19+(1/2)*ch4+(1/2)*ch5)/2
% 
% C4: ch21 =(ch18+ch25+(1/2)*ch6+(1/2)*ch12)/3
% C3: ch22 =(ch19+ch26+(1/2)*ch13+(1/2)*ch6)/3
% 
% P4: ch8 =(ch25+(1/2)*ch7+(1/2)*ch10)/2
% P3: ch9 =(ch26+(1/2)*ch11+(1/2)*ch7)/2
% 
% Cz = (2Fcz+Pz)/3 ch6=(2*ch20+ch7)/3

 
