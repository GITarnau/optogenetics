clear all
close all

addpath('C:\Users\Arnaud\Documents\Fiji.app')
addpath('C:\Users\Arnaud\Documents\Fiji.app\scripts')

button = questdlg('Open Fiji?','Fiji','yes','no', 'yes');

switch button
    case 'no'
 
   errordlg('You need to open Fiji','File Error');

    case 'yes'

ImageJ;
end
ij.IJ.setTool('polyline'); 

%line thickness set to 5 pixel
ij.IJ.run('Line Width...', 'line=3');

while string(button) == 'yes'

button = questdlg('Did you draw a line','Line','yes','no', 'yes');

if string(button) == 'no';
 
    errordlg('You need to draw a line','File Error');

elseif string(button) == 'yes';
%    h = msgbox('Thank you the analysis will continue');

% Fit a spline line
 ij.IJ.run('Fit Spline');
 
 % Verfies the line drawing quality
button = questdlg('Are you satisfied with your drawing?','Drawing','yes','no', 'yes');

 
switch button
    case 'no'
 
   msgbox('Please adjust the line');

    case 'yes'
        
        
     %calls macro to get x & y coordinates
   ij.IJ.runMacroFile(java.lang.String('XY_Coordinat.ijm'));
   %calls a macro to get the intensity values 
   ij.IJ.runMacroFile(java.lang.String('intensity_val.ijm'));
% optional: this macro calculates the angle along the line 
%ij.IJ.runMacroFile(java.lang.String('Ang.ijm'));
   
   gn = inputdlg('Please name your file including the ".txt" extension');
  g_name=gn{1};


ij.IJ.saveAs('Text', 'Z:\Arnaud\UW\All_Matlab_Codes\oput.txt');
  movefile('Z:\Arnaud\UW\All_Matlab_Codes\oput.txt',g_name)
  
  %clears the console
   ij.IJ.runMacroFile(java.lang.String('clear_log'));
close();
end
button = questdlg('Would you like to analyze more wonderful neuroblasts?','Continue analysis?','yes','no', 'yes');    
end
 end

movefile('Z:\Arnaud\UW\All_Matlab_Codes\optogenetics\*.txt', 'Z:\Arnaud\UW\All_Matlab_Codes\output');

 %closes the open windows
ij.IJ.runMacroFile(java.lang.String('close.ijm'));
close();

msgbox('Thank you your part is done, let the Matlab magic happen!');

cd 'Z:\Arnaud\UW\All_Matlab_Codes\output';

D = dir('*.txt');
l = length(D(not([D.isdir])));
% fopen('results.txt','w');


for kl=1:l

z=textread(D(kl).name,'%s','delimiter','\n','whitespace','');

% name of the current text file without the ".txt" extension
n_file=D(kl).name(1:end-4);

% calculates the length of the log file, coordinate and intensity are equal
% the length will be used to separate coordinates and intensity
p=(length(z))/2;

% fill the matrix of coordinates values
for k=1:p
    z2(k)=z(k);
end
z3= str2num(char(z2));

% normalised length
uzt=(z3(:,1)/ (length(z3)-1));
% new matrix with normalised position (0-1) and x&y coordinates
uzr=[uzt z3];

% fill the matrix of intensity values
ind=1;
for k2= p+1:length(z)
    z4(ind)=z(k2);
    ind=ind+1;
end
z5=str2num(char(z4));
z7= LineCurvature2D(z3(:,2:end));
z6= [uzr z5 z7];

%calculates correlation between intensity and curvature 
[r, p]=corrcoef(z6(:,5),z6(:,6));
% output is two symmetric matrices since we only compare 2 columns, we only
% get one value for correlation coefficient and the p value

rho = r(1,2); 
pval = p(1,2); 
corr_res =  [rho pval];


%column headers
col_header={'normalized position [0,1]','point number','X','Y','intensity values','curvature', 'correlation coefficient', 'correlation P-value'};


% Writes into an excel file:
% normalized position [0,1]
% point number
% x & y coordinate
% intensity values
% curvature


% writes the column headers into a new excel file
xlswrite(strcat(n_file,'.xls'),col_header,'Sheet1','A1');
% writes the results below in the same excel file
xlswrite(strcat(n_file,'.xls'),z6,'Sheet1','A2');
xlswrite(strcat(n_file,'.xls'),corr_res,'Sheet1','G2');
end


fclose('all');