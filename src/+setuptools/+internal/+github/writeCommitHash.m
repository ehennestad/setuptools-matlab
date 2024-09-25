function writeCommitHash(repositoryFolderPath, repositoryName, organizationName, branchName)
    commitId = setuptools.internal.github.api.getCurrentCommitID(repositoryName, ...
        'Organization', organizationName, "BranchName", branchName);
    filePath = fullfile(repositoryFolderPath, '.commit_hash');
    setuptools.internal.utility.filewrite(filePath, commitId)
end
