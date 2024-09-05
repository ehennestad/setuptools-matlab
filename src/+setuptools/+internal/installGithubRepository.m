function repoTargetFolder = installGithubRepository(repositoryUrl, branchName, options)

    arguments
        repositoryUrl (1,1) string
        branchName (1,1) string = "main"
        options.Update (1,1) logical = false
        options.InstallationLocation (1,1) string = setuptools.internal.getDefaultAddonFolder()
    end

    if ismissing(branchName); branchName = "main"; end

    [organization, repoName] = setuptools.internal.github.parseRepositoryURL(repositoryUrl);
    
    if ~options.Update
        [repoExists, repoPath] = setuptools.internal.pathtool.lookForRepository(repoName, branchName);
        if repoExists
            return
        end
    end
    
    % Todo: Implement updating
    % if repoExists
    %     if options.Update
    %         % Todo: Delete old repo and download again.
    %     else
    %         return
    %     end
    % end

    targetFolder = options.InstallationLocation;
    repoTargetFolder = fullfile(targetFolder);

    if ~isfolder(repoTargetFolder); mkdir(repoTargetFolder); end

    % Download repository
    downloadUrl = sprintf( '%s/archive/refs/heads/%s.zip', repositoryUrl, branchName );
    repoTargetFolder = setuptools.internal.downloadZippedGithubRepo(downloadUrl, repoTargetFolder, true, true);

    commitId = setuptools.internal.github.api.getCurrentCommitID(repoName, 'Organization', organization, "BranchName", branchName);
    filePath = fullfile(repoTargetFolder, '.commit_hash');
    setuptools.internal.utility.filewrite(filePath, commitId)
    
    % Run setup.m if present.
    setupFile = setuptools.internal.findSetupFile(repoTargetFolder);
    if isfile( setupFile )
        run( setupFile )
    else
        addpath(genpath(repoTargetFolder));
    end
end
