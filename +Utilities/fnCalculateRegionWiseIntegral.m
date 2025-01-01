%% Function to calculate integrals of regions and sum them 
function regionWiseIntegral = fnCalculateRegionWiseIntegral(x, y, regions)

    % Get the number of regions
    nRegions = numel(regions);

    % Initialise an array of integrals for the regions
    regionIntegrals = zeros([nRegions, 1]);

    % Loop through each of the regions
    for i = 1:nRegions

        % Get the region array
        regionArray = regions{i};

        % Get the start and end idx
        startIdx = regionArray(1);
        endIdx = regionArray(2);

        % Get the data for the region
        xRegion = x(startIdx:endIdx);
        yRegion = y(startIdx:endIdx);

        % Calculate the intergal for the region
        regionIntegrals(i) = trapz(xRegion, yRegion);

    end

    % Sum the individual areas
    regionWiseIntegral = sum(regionIntegrals);




end