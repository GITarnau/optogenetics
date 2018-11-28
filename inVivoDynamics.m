%% This code will open fiji, take image sequences as input, ask the user to draw a line and then a region and will return the mean 
%%for each timpepoint as well as the ratio between the line and the region
%%and write it in an excel file
%%
clear all
close all

addpath('C:\Users\Arnaud\Documents\Fiji.app');
addpath('C:\Users\Arnaud\Documents\Fiji.app\scripts');

button = questdlg('Hey! Open Fiji?','Fiji','yes','no','yes');

switch button
    case 'no'
        errordlg('You need to open Fiji','File Error');
    case 'yes'
        Miji;
end
kl=0;
while string(button) == 'yes'
    kl=kl+1;
    
    ij.IJ.setTool('polyline');
    
    %line thickness set to 5 pixel
    ij.IJ.run('Line Width...', 'line=50');
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
                
                % get the mean intensity on the line(for the cortex)  for each timepoints
                ij.IJ.runMacroFile(java.lang.String('zprofileValues'));
                % saves the data in a text file
                ij.IJ.saveAs("Results", "Z:\Arnaud\UW\All_Matlab_Codes\oput.txt");
                %clears the console
%                 ij.IJ.runMacroFile(java.lang.String('clear_log'));
%                 close();
                ij.IJ.runMacroFile(java.lang.String('close'));
                button = questdlg('Measure mean cytoplasmic intensity?','Cytoplasmic intensity','yes','no','yes');
                
        end
        
        %measure the mean intensity of the cytoplasm
        switch button
            
            case 'yes'
                
                ij.IJ.setTool('polygon');
                
                button = questdlg('Did you draw a polygon','Line','yes','no', 'yes');
                
                if string(button) == 'no';
                    
                    errordlg('You need to draw a polygon','File Error');
                    
                elseif string(button) == 'yes';
                    ij.IJ.run('Fit Spline');
                       % get the mean intensity on the line(for the cortex)  for each timepoints
                   ij.IJ.runMacroFile(java.lang.String('zprofileValues'));
                   ij.IJ.saveAs("Results", "Z:\Arnaud\UW\All_Matlab_Codes\oput2.txt");
                   ij.IJ.runMacroFile(java.lang.String('close')); 
                    
                end
        end
        
        
    end
    %saves the cortex and cytoplasmic intensity as local variable and
    %calculates the ratio
    cort =textread('oput.txt','%s','delimiter','\n','whitespace','');
    cyt =textread('oput2.txt','%s','delimiter','\n','whitespace','');
    cortex= str2num(char(cort(2:end)));
    cyto= str2num(char(cyt(2:end)));
    ratio=(cortex(:,2)./cyto(:,2));
    Tnormalized= (cortex(:,1)).*20;
    
    uzs= [cortex(:,1) Tnormalized cortex(:,2) cyto(:,2) ratio];
   
C={'Timepoint','Normlized time (s)','Cortical Intensity','Cytoplasmic Intensity','Normalized Cortical/Cytoplasmic Ratio','Exponential Fit'}; 
xlswrite('results.xls',C,strcat((int2str(kl)),'_neuroblast'),'A1');
xlswrite('results.xls',[uzs],strcat((int2str(kl)),'_neuroblast'),'A2');

   delete *.txt;
    
    button = questdlg('Would you like to analyze more Neuroblasts?','Continue analysis?','yes','no', 'yes');
    
   
   
    
end
%closes the open windows
%ij.IJ.runMacroFile(java.lang.String('close.ijm'));
ij.IJ.run('Close All');

%closes Fiji
ij.IJ.run('Quit');

msgbox('Thank you! Your part is done, let the Matlab magic happen!');


excelFileName = 'restults.xls';
excelFilePath = pwd; % Current working directory.

sheetName = 'Sheet';
e = actxserver('Excel.Application'); % # open Activex server
ewb = e.Workbooks.Open('Z:\Arnaud\UW\All_Matlab_Codes\results.xls'); % Full path

e.ActiveWorkbook.Worksheets.Item([sheetName '1']).Delete; %delete first sheet

ewb.Save % # save to the same file
ewb.Close(false)
e.Quit



fclose('all');