function startup_project()
%STARTUP_PROJECT  Put the project folders on the MATLAB path.
%   Run once per MATLAB session before building, testing or opening models.

root = fileparts(mfilename('fullpath'));
addpath(fullfile(root, 'params'), fullfile(root, 'src'), fullfile(root, 'src', 'lib'), ...
        fullfile(root, 'tests'), fullfile(root, 'tests', 'lib'));
for folder = {'models', 'results'}
    if ~isfolder(fullfile(root, folder{1})), mkdir(fullfile(root, folder{1})); end
end
addpath(fullfile(root, 'models'));
fprintf('Project paths added: %s\n', root);
end
