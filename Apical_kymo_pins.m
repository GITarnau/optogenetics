clear all;
clc;

%add path for running Fiji and imaris from matlab
% addpath('C:\Users\Arnaud\Fiji.app');
% addpath('C:\Users\Arnaud\Fiji.app\scripts');



% opens the subfolder where input/output folder prompts
folders= 'F:\UW\imaging_data\Optogenetics\Pins\Intensity analysis';

%opens Fiji 
ImageJ;

 ij.IJ.setTool('polyline');
   %line thickness set to 9 pixel
    ij.IJ.run('Line Width...', 'line=7');
    
   

% user defines input  folder
input = uigetdir(folders, 'Select an input C1 folder');
% user defines input  folder2
input2 = uigetdir(folders, 'Select an input C2 folder');
% user defines the output folder
% get the list of all the files in the input directory
list2 = dir(fullfile(input2, '*.tif'));
output = uigetdir(folders, 'Select an output C1 folder');
% get the list of all the files in the input directory
list = dir(fullfile(input, '*.tif'));
% user defines the output folder2
output2 = uigetdir(folders, 'Select an output C2 folder');





for i=1:length(list)
       
    
    

    filename = strcat(input,'\',list(i).name)
    filename2 = strcat(input2,'\',list2(i).name)
    ij.IJ.open(filename);
    
  
    
    button = questdlg('Did you draw a line?','Line','yes','no', 'yes');
    
    
    switch button
        case 'no'   
            msgbox('Please adjust the line');     
        case 'yes'  
            % Spline line
%     ij.IJ.run('Fit Spline');
          % Verfies the line drawing quality
    button = questdlg('Is the line ok?','Line','yes','no', 'yes');   
        switch button
        case 'no'   
            msgbox('Please adjust the line');     
        case 'yes'    
    
            
 
    %extracts kymograph from drawn line of width 9
            ij.IJ.run("Multi Kymograph", "linewidth=7");
            % apply Rainbow RGB LUT to the image
            ij.IJ.run("Rainbow RGB");
            %concatenate the name consisitently with the image openened and
            %saves the kymo as a tiff in the output directory
            outputname =strcat('Kymo-',list(i).name,'.tif');
            target=strcat(output,'\',outputname);
            ij.IJ.saveAs("Tiff", target);
    %opens the second channel & copy the ROI and saves the kymo for the second channel 
    ij.IJ.open(filename2);
     ij.IJ.run("Restore Selection");
     ij.IJ.run("Multi Kymograph", "linewidth=3")   
     ij.IJ.run("Rainbow RGB");
     outputname2 =strcat('Kymo-',list2(i).name,'.tif');
            target2=strcat(output2,'\',outputname2);
            ij.IJ.saveAs("Tiff", target2);
     end
end
end
%quits ImageJ
ij.IJ.run('Quit');
