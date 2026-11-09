function new_model(mdl)
%NEW_MODEL  Create an empty model, closing any loaded copy without saving.
if bdIsLoaded(mdl), close_system(mdl, 0); end
new_system(mdl);
load_system('simulink');
end
