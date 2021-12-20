clear; clc;

%import geometry
gm = importGeometry('Bridge_support.stl');
%create model
model = createpde('structural','modal-solid');
model.Geometry = gm;
structuralProperties(model,'YoungsModulus',200e9, ...
                                     'PoissonsRatio',0.3, ...
                                     'MassDensity',7850);
generateMesh(model,'Hmax',5);
%
boundries=structuralBC(model,'Face',6,'Constraint','fixed')
%vyplotuješ 3d model
pdegplot(gm,'CellLabels','on', 'FaceLabels','on');
%solvuješ
RF = solve(model,'FrequencyRange',[0,100]); %*2*pi

modeID = 1:numel(RF.NaturalFrequencies);
tmodalResults = table(modeID.',RF.NaturalFrequencies); %/(2*pi)
tmodalResults.Properties.VariableNames = {'Mode','Frequency'};
disp(tmodalResults);


pdeplot3D(model,'ColorMapData',RF.ModeShapes.y(:,24));
title(['First Mode with Frequency ', ...
        num2str(RF.NaturalFrequencies(24)),' Hz'])
axis equal