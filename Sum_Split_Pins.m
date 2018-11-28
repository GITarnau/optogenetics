clear all;
clc;

% %add path for running Fiji and imaris from matlab
% addpath('C:\Users\Arnaud\Documents\Fiji.app');
% addpath('C:\Users\Arnaud\Documents\Fiji.app\scripts');
% addpath('C:\Program Files\Bitplane\Imaris x64 9.0.1\XT\matlab');


%opens Fiji 
ImageJ;




% user defines input folder
input = uigetdir('F:\UW\imaging_data\Optogenetics\Pins\Intensity analysis', 'Select an input folder');
% user defines the output folder
output = uigetdir('F:\UW\imaging_data\Optogenetics\Pins\Intensity analysis', 'Select an output folder');


% get the list of all the files in the input directory
list = dir(fullfile(input, '*.ims'));

for i=1:length(list)

filename= strcat(input,'\',list(i).name)

ij.IJ.open(filename);
ij.IJ.run("Z Project...", "projection=[Sum Slices] all");
ij.IJ.run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear stack");

ij.IJ.run("Split Channels");

name1=strcat('C1-SUM_',list(i).name);
name2=strcat('C2-SUM_',list(i).name);

ij.IJ.selectWindow(name1);
ij.IJ.run("Grays");
ij.IJ.saveAs("Tiff", strcat(output,'\',name1));

ij.IJ.selectWindow(name2);
ij.IJ.run("Grays");
ij.IJ.saveAs("Tiff", strcat(output,'\',name2));

% ij.IJ.runMacroFile(java.lang.String('close'));

end
ij.IJ.run('Quit');
