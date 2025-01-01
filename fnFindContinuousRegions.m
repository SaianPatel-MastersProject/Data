function regions = fnFindContinuousRegions(logicalArray)
    % Initialize variables
    regionsInit = {};  % Cell array to store indices of continuous regions
    startIdx = []; % Start index of a region
    n = length(logicalArray);
    
    % Loop through the logical array
    for i = 1:n
        if logicalArray(i) % If the current value is true
            if isempty(startIdx) % Start of a new region
                startIdx = i;
            end
        else
            if ~isempty(startIdx) % End of a region
                regionsInit{end+1} = startIdx:i-1; % Add the region to the list
                startIdx = []; % Reset start index
            end
        end
    end
    
    % Handle the case where the last region extends to the end of the array
    if ~isempty(startIdx)
        regionsInit{end+1} = startIdx:n;
    end

    % Loop through each of the regions
    nRegions = length(regionsInit);

    % Initilaise new regions
    regions = {};

    for i = 1:nRegions

        % Only keep regions with more than 1 point
        if numel(regionsInit{i}) > 1

            % Region array
            regionArray = regionsInit{i};

            % Get the region start and end index
            startIdx = regionArray(1);
            endIdx = regionArray(end);

            % Populate the new regions cell
            if isempty(regions)

                regions{1} = [startIdx, endIdx];

            else

                regions{end+1} = [startIdx, endIdx];

            end

        end


    end

end
