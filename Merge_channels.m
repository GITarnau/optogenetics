clear all;

%add path for running Fiji and imaris from matlab
addpath('C:\Users\Arnaud\Documents\Fiji.app');
addpath('C:\Users\Arnaud\Documents\Fiji.app\scripts');
addpath('C:\Program Files\Bitplane\Imaris x64 9.0.1\XT\matlab');


%opens Fiji without GUI
Miji(false);

%connects to imaris
conn = IceImarisConnector();
conn.startImaris();
vImarisApplication = conn.mImarisApplication;


% user defines input folder
input = uigetdir('Z:\Arnaud\UW\imaging_data\converted files', 'Select an input folder');

% user defines the output folder
output = uigetdir('Z:\Arnaud\UW\imaging_data\converted files', 'Select an output folder');
% user defines the pins folder
pins = uigetdir('Z:\Arnaud\UW\imaging_data\converted files', 'Select the pins folder');

% get the list of all the files in the input directory
list = dir(fullfile(input, '*.ims'));
% get the list of all the pins files in the pins directory
list2 = dir(fullfile(pins, '*.ims'));

for i=1:length(list)
Miji(false);
filename= strcat(input,'\',list(i).name)

filename2= strcat(pins,'\',list2(i).name)

ij.IJ.open(filename2);

ij.IJ.run("Split Channels");

% Pins_Jupiter=list2(i).name;
% Pins_Jupiter=Pins_Jupiter(1:end-4);
Pins_Jupiter =strcat('C1-',list2(i).name);
ij.IJ.open(filename);
 
merged=strcat('c4=',Pins_Jupiter,' c2=',list2(i).name);

ij.IJ.run("Merge Channels...",merged);

ij.IJ.run("Image To Imaris", "=[Id 0: Imaris x64 9.0.1 [Sep  5 2017] ]");

outputname3 =strcat('pins-jupiter-sqh-lobe-',filename(length(filename)-4),'.ims');
target=strcat(output,'\',outputname3);
vImarisApplication.FileSave(target, 'writer="Imaris5"');

ij.IJ.run('Quit');
end

