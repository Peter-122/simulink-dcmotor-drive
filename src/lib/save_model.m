function save_model(mdl)
%SAVE_MODEL  Save a model into the project's models/ folder.
file = fullfile(project_root, 'models', [mdl '.slx']);
save_system(mdl, file);
fprintf('Built %s\n', file);
end
