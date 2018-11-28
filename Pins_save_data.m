%add path for running Fiji and imaris from matlab
addpath('C:\Users\Arnaud\Documents\Fiji.app');
addpath('C:\Users\Arnaud\Documents\Fiji.app\scripts');
addpath('C:\Program Files\Bitplane\Imaris x64 9.0.1\XT\matlab');
Miji(false);

conn = IceImarisConnector();
conn.startImaris();
vImarisApplication = conn.mImarisApplication;


% user defines input  folder
input = uigetdir('Z:\Arnaud\UW\imaging_data\converted files', 'Select an input folder');
% user defines the output folder
output = uigetdir('Z:\Arnaud\UW\imaging_data\converted files', 'Select an outpput folder');
% get the list of all the files in the input directory
list = dir(fullfile(input, '*.ims'));

for i=1:length(list)
Miji(false);
filename = strcat(input,'\',list(i).name)

ij.IJ.open(filename);
ij.IJ.run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=24 frames=100 display=Grayscale");
ij.IJ.run("Duplicate...", "duplicate slices=5-24");

% filename2=strcat(filename,'-1');

ij.IJ.run("Properties...", "channels=1 slices=20 frames=100 unit=micron pixel_width=0.23 pixel_height=0.23 voxel_depth=1 frame=[15 sec] global");
ij.IJ.run("Image To Imaris", "=[Id 0: Imaris x64 9.0.1 [Sep  5 2017] ]");

outputname =strcat('sqh-lobe-',filename(length(filename)-4),'.ims');
target=strcat(output,'\',outputname);
vImarisApplication.FileSave(target, 'writer="Imaris5"');

ij.IJ.run("Duplicate...", "duplicate slices=9-11");
ij.IJ.run("Image To Imaris", "=[Id 0: Imaris x64 9.0.1 [Sep  5 2017] ]");

outputname =strcat('sqh-midplane-lobe-',filename(length(filename)-4),'.ims');
target=strcat(output,'\',outputname);
vImarisApplication.FileSave(target, 'writer="Imaris5"');

ij.IJ.run('Quit');
end
