function DiameterArea2D ()
% Function which measures the diameters and returns ratios
%
% The function will ask the user to measure the radii of the neuroblast the
% GMC and the ectopic furrow and returns the different ratios in an excel
% file stored in the matlab output folder

%%

%optional (slows the function down) starts fiji (if Fiji is already running nothing will happen)
% ImageJ;
% sets the initial diameter and area values to 0

Nb_d=0;
Nb_a=0;

GMC_d=0;
GMC_a=0;

Ect_d=0;
Ect_a=0;




% sets the line tool on Fiji
ij.IJ.setTool('line');

button = questdlg('Did you draw a line for the Neuroblast Diameter','NB diameter','yes','no', 'yes');

%measures the distance if the user has drawn a line else nothing happens
switch button
    case 'yes'
        ij.IJ.run('Measure');
        Nb_d = ij.plugin.filter.Analyzer.getResultsTable().getValue('Length',0);% NB diameter of the first row
        
end
ij.IJ.deleteRows(0, 0);% clears the Results
%sets the ellipse tool on Fiji
ij.IJ.setTool('oval');

button = questdlg('Did you draw an ellipse for the Neuroblast Area','NB Area','yes','no', 'yes');

%measures the area
switch button
    case 'yes'
        ij.IJ.run('Measure');
        Nb_a = ij.plugin.filter.Analyzer.getResultsTable().getValue('Area',0);
        
end
ij.IJ.deleteRows(0, 0);% clears the Results


% sets the line tool in Fiji
ij.IJ.setTool('line');

button = questdlg('Did you draw a line for the GMC Diameter','GMC diameter','yes','no', 'yes');

switch button
    case 'yes'
        ij.IJ.run('Measure');
        GMC_d = ij.plugin.filter.Analyzer.getResultsTable().getValue('Length',0);% NB diameter of the first row
        
end
ij.IJ.deleteRows(0, 0);% clears the Results
%sets the ellipse tool on Fiji
ij.IJ.setTool('oval');

button = questdlg('Did you draw an ellipse for the GMC Area','GMC Area','yes','no', 'yes');

%measures the area
switch button
    case 'yes'
        ij.IJ.run('Measure');
        GMC_a = ij.plugin.filter.Analyzer.getResultsTable().getValue('Area',0);% NB diameter of the first row
        
end
ij.IJ.deleteRows(0, 0);% clears the Results







% sets the line tool in Fiji
ij.IJ.setTool('line');
button = questdlg('Did you draw a line for the ectopic furrow Diameter','Ectopic diameter','yes','no', 'yes');

switch button
    
    case 'yes'
        ij.IJ.run('Measure');
        Ect_d = ij.plugin.filter.Analyzer.getResultsTable().getValue('Length',0);% NB diameter of the first row
        
end
ij.IJ.deleteRows(0, 0);% clears the Results
%sets the ellipse tool on Fiji
ij.IJ.setTool('oval');

button = questdlg('Did you draw an ellipse for the ectopic furrow Area','Ectopic Area','yes','no', 'yes');

%measures the area
switch button
    case 'yes'
        ij.IJ.run('Measure');
        Ect_a = ij.plugin.filter.Analyzer.getResultsTable().getValue('Area',0);% NB diameter of the first row
        
end
ij.IJ.deleteRows(0, 0);% clears the Results

%Line titles
L_title={'NB diameter','NB Area','GMC diameter','GMC area','Ectopic diameter','Ectopic Area'}';



gna = inputdlg('Please name your file including the ".xls" extension');
g_na=gna{1};

Res= [Nb_d Nb_a GMC_d GMC_a Ect_d Ect_a]';
xlswrite(g_na,L_title,'Sheet1','A1');
xlswrite(g_na,Res,'sheet1','B1');

end


