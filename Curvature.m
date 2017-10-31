clear all
close all
fn= 'nothingwrittenyet';
addpath('C:\Users\Arnaud\Documents\Fiji.app')
addpath('C:\Users\Arnaud\Documents\Fiji.app\scripts')

button = questdlg('Open Fiji?','Fiji','yes','no', 'yes');

 
if button == 'no';
 
   errordlg('You need to open Fiji','File Error');

elseif button == 'yes';

ImageJ;
end
ij.IJ.setTool('polyline'); 
ij.IJ.run('Line Width...', 'line=5');

while button == 'yes'

button = questdlg('Did you draw a line','Line','yes','no', 'yes');

if button == 'no';
 
    errordlg('You need to draw a line','File Error');

elseif button == 'yes';
   h = msgbox('Thank you the analysis will continue');
 ij.IJ.run('Fit Spline');
 
   ij.IJ.runMacroFile(java.lang.String('XY_Coordinat.ijm'));
   ij.IJ.runMacroFile(java.lang.String('intensity_val.ijm'));
%    ij.IJ.runMacroFile(java.lang.String('Ang.ijm'));
   
   g_name = inputdlg('Please name your file including the ".txt" extension')
  


ij.IJ.saveAs('Text', 'Z:\Arnaud\UW\All_Matlab_Codes\oput.txt');
  movefile('Z:\Arnaud\UW\All_Matlab_Codes\oput.txt',g_name)
%  movefile('F:\UW\*.txt', 'F:\\UW\\curvature\\Results');
 ij.IJ.runMacroFile(java.lang.String('close.ijm'));
close();
end
button = questdlg('Would you like to analyze more wonderful neuroblasts?','Continue analysis?','yes','no', 'yes');
end

ij.IJ.runMacroFile(java.lang.String('close.ijm'));
close();

h = msgbox('Thank you your part is done, let the Matlab magic happen!');



D = dir('*.txt');
l = length(D(not([D.isdir])));
% fopen('results.txt','w');


for kl=1:l

z=textread(D(kl).name,'%s','delimiter','\n','whitespace','');


% calculate the length of the log file, coordinate and intensity are equal
% the length will be used to separate coordinates and intensity
p=(length(z))/2;

% fill the matrix of coordinates values
for k=1:p
    z2(k)=z(k);
end
z3=str2num(char(z2));

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

%

z7= LineCurvature2D(z3(:,2:end));
z6= [uzr z5 z7];






% dlmwrite('results.txt',[z6],'-append','delimiter',' ','roffset',5);
dlmwrite(strcat(int2str(kl),'.txt'),[z6],'delimiter','\t','precision',6);
xlswrite(strcat(int2str(kl),'.xls'),[z6]);
end


fclose('all');