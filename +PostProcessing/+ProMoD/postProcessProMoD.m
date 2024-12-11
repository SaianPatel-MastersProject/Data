function postProcessProMoD(matFilePath)

    % Read in a run .mat file
    load(matFilePath);

    % Calculate steering aggressiveness (MSteer)
    MSteer = PostProcessing.ProMoD.calculateSteeringAggressiveness(runStruct);

    dataProMoD.MSteer = MSteer;

    % Write the ProMoD table as a layer
    % Set the .mat filename
    ProMoD_matFilePath = strrep(matFilePath, '.mat', '_ProMoD.mat');

    % Save the .mat
    save(ProMoD_matFilePath, 'dataProMoD');



end