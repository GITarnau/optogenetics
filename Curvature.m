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
ij.IJ.run('Line Width...', 'line=5');

while string(button) == 'yes'

button = questdlg('Did you draw a line','Line','yes','no', 'yes');

if string(button) == 'no';
 
    errordlg('You need to draw a line','File Error');

elseif string(button) == 'yes';
%    h = msgbox('Thank you the analysis will continue');
% Fit a spline line
 ij.IJ.run('Fit Spline');
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

 ij.IJ.runMacroFile(java.lang.String('close.ijm'));
close();
end
button = questdlg('Would you like to analyze more wonderful neuroblasts?','Continue analysis?','yes','no', 'yes');
end

movefile('Z:\Arnaud\UW\All_Matlab_Codes\optogenetics\*.txt', 'Z:\Arnaud\UW\All_Matlab_Codes\output');
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


%column headers
col_header={'normalized position [0,1]','point number','X','Y','intensity values','curvature'};

% dlmwrite('results.txt',[z6],'-append','delimiter',' ','roffset',5);
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
end


fclose('all');