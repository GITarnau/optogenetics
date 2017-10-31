clear all
close all
fn= 'nothingwrittenyet';
addpath('C:\Users\Arnaud\Documents\Fiji.app')
addpath('C:\Users\Arnaud\Documents\Fiji.app\scripts')

repeat = 'y';
prompt= 'Open Fiji? [Y/N]   ';

sent= input(prompt, 's');
 
if sent == 'N'|sent == 'n' ;
 
    display('Nothing will happen then!');

elseif sent == 'Y'|sent == 'y' ;

ImageJ;
end
ij.IJ.setTool('polyline'); 
ij.IJ.run('Line Width...', 'line=5');

while repeat == 'y'|repeat == 'Y' ;

prompt = 'Please drag a file and draw a line. Did you draw a line? [Y/N]  ';
str = input(prompt, 's');

if str == 'N'| str == 'n' ;
 
    display('Please start again and follow the instructions');

elseif str == 'Y'| str == 'y';
   display ('Thank you the analysis will continue');
 ij.IJ.run('Fit Spline');
 
   ij.IJ.runMacroFile(java.lang.String('XY_Coordinat.ijm'));
   ij.IJ.runMacroFile(java.lang.String('intensity_val.ijm'));
%    ij.IJ.runMacroFile(java.lang.String('Ang.ijm'));
   
   prompt = 'Please name your file and do not forget the extension ".txt"?';
   fn = input(prompt, 's');


ij.IJ.saveAs('Text', 'Z:\Arnaud\UW\All_Matlab_Codes\oput.txt');
  movefile('Z:\Arnaud\UW\All_Matlab_Codes\oput.txt',fn)
%  movefile('F:\UW\*.txt', 'F:\\UW\\curvature\\Results');
 ij.IJ.runMacroFile(java.lang.String('close.ijm'));
close();
end
prompt= 'Would you like to analyze more wonderful neuroblasts? Y/N';
repeat= input(prompt, 's');
end

ij.IJ.runMacroFile(java.lang.String('close.ijm'));
close();

display ('Thank you your part is done, let the Matlab magic happen!');




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