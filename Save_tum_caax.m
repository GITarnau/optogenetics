clear all;

%add path for running Fiji and imaris from matlab
addpath('C:\Users\Arnaud\Fiji.app');
addpath('C:\Users\Arnaud\Fiji.app\scripts');

%opens Fiji 
ImageJ;

% user defines input folder
input = uigetdir('Z:\Arnaud\UW\imaging_data\converted files', 'Select an input folder');
% user defines the output folder
output = uigetdir('Z:\Arnaud\UW\imaging_data\converted files', 'Select an output folder');
% user defines the pins folder
sqh = uigetdir('Z:\Arnaud\UW\imaging_data\converted files', 'Select the sqh folder');

% get the list of all the files in the input directory
list = dir(fullfile(input, '*.ims'));
% get the list of all the pins files in the pins directory
list2 = dir(fullfile(sqh, '*.ims'));

for i=1:length(list)


%path to file location
filename= strcat(input,'\',list(i).name)
filename2= strcat(sqh,'\',list2(i).name)
% opens first file
ij.IJ.open(filename);
%converts stack to hyperstack 
ij.IJ.run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=60 frames=150 display=Grayscale");
%specfies voxel size and time interval
ij.IJ.run("Properties...", "channels=1 slices=60 frames=160 unit=micron pixel_width=0.23 pixel_height=0.23 voxel_depth=1 frame=[15 sec] global");
%duplicates slices 32-60 of cam2
ij.IJ.run("Duplicate...", "duplicate slices=32-60");


%saves the file as an imaris file in the output folder
outputname2 =strcat('caax-lobe-',filename(length(filename)-4),'.tif');
target=strcat(output,'\',outputname2);
ij.IJ.saveAs("Tiff", target);


%opens pins-jupiter file
ij.IJ.open(filename2);
%duplicate slices 1-29 (last timepoint is not working) 
ij.IJ.run("Duplicate...", "duplicate slices=1-29");


%splits channels
ij.IJ.run("Split Channels");
ij.IJ.run("Properties...", "channels=1 slices=29 frames=150 unit=micron pixel_width=0.23 pixel_height=0.23 voxel_depth=1 frame=[15 sec] global");

% specify the name file of C4 for later channels merging
sqh_caax_tum =strcat('[C1-',list2(i).name,' - ',{' '}, list2(i).name,' Resolution Level 1-1]');


sqh=list(i).name;
sqh=sqh(1:end-4);
sqh =strcat(sqh,'-1.tif');


merged= strcat('c2=',sqh,' c4=',sqh_caax_tum);

ij.IJ.run("Merge Channels...",merged);

% ij.IJ.run("Image To Imaris", "=[Id 0: Imaris x64 9.0.1 [Sep  5 2017] ]");

outputname3 =strcat('pins-jupiter-sqh-lobe-',filename(length(filename)-4),'.tif');
target=strcat(output,'\',outputname3);

ij.IJ.saveAs("Tiff", target);

%closes the open windows
ij.IJ.run('Close All');

end
%closes Fiji
ij.IJ.run('Quit');
