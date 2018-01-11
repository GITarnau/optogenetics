clear all
close all

addpath('C:\Users\Arnaud\Documents\Fiji.app');
addpath('C:\Users\Arnaud\Documents\Fiji.app\scripts');

button = questdlg('Hey Temo! Open Fiji?','Fiji','yes','no', 'yes');

switch button
    case 'no'
        
        errordlg('You need to open Fiji','File Error');
        
    case 'yes'
        
        Miji;
end


while string(button) == 'yes'
    
    ij.IJ.setTool('polyline');
    
    %line thickness set to 3 pixel
    ij.IJ.run('Line Width...', 'line=3');
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
                
                button = questdlg('Would you like to measure Diameter and Area?','Diameter and Area','yes','no', 'yes');
                
                
        end
        %measure diameter and area if the user wants it
        switch button
            case 'yes'
                % caclulates the diameter of the neuroblast, the GMC and
                % the ectopic furrow
                DiameterArea2D
        end
    end
        button = questdlg('Would you like to analyze more timepoints?','Continue analysis?','yes','no', 'yes');
    
end

% moves all the result files to the output folder
movefile('Z:\Arnaud\UW\All_Matlab_Codes\*.txt', 'Z:\Arnaud\UW\All_Matlab_Codes\output');
 movefile('Z:\Arnaud\UW\All_Matlab_Codes\*.xls', 'Z:\Arnaud\UW\All_Matlab_Codes\output');

%closes Fiji
ij.IJ.run('Quit');
%closes the open windows
% ij.IJ.runMacroFile(java.lang.String('close.ijm'));
% close();

msgbox('Thank you Temo! Your part is done, let the Matlab magic happen!');

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
    %intensity 1 column matrix 
    z5=str2num(char(z4));
    
 % normalized intensity by the max 
   z8= z5/max (z5);
    
   
    
    %calculates the line curvature
    z7= LineCurvature2D(z3(:,2:end));
    z6= [uzr z5 z8 z7];
    
    %calculates correlation between intensity and curvature
    [r, p]=corrcoef(z6(:,5),z6(:,7));
    % output is two symmetric matrices since we only compare 2 columns, we only
    % get one value for correlation coefficient and the p value
    
    rho = r(1,2);
    pval = p(1,2);
    corr_res =  [rho pval];
    
    
    %column headers
    col_header={'normalized position [0,1]','point number','X','Y','intensity values', 'normalized intensity','curvature', 'correlation coefficient', 'correlation P-value'};
    
    
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
    xlswrite(strcat(n_file,'.xls'),corr_res,'Sheet1','H2');
end


fclose('all');