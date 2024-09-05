function requirements = getRequirements(packageRootDirectory)
% getRequirements - Get toolbox requirements / dependencies
    
    arguments
        packageRootDirectory (1,1) string
    end
    
    requirementsStr = fileread(fullfile(packageRootDirectory, 'requirements.txt'));

    requirements = splitlines(requirementsStr);

    isEmpty = cellfun('isempty', requirements);
    requirements(isEmpty) = [];

    requirements = parseRequirements(requirements);
end

function parsedRequirements = parseRequirements(requirements) % Needed?

    parsedRequirements = struct;

    for i = 1:numel(requirements)
        
        if startsWith(requirements{i}, "fex://")
            type = 'FileExchange';
        elseif startsWith(requirements{i}, "https://github.com")
            type = 'GitHub';
        else
            type = 'Unknown';
            warning('Unsupported requirement specification: %s', requirements{i})
        end
        
        parsedRequirements(i).Type = type;
        parsedRequirements(i).URI = string(requirements{i});
    end

    parsedRequirements = parsedRequirements( ~cellfun('isempty', requirements) );
end
