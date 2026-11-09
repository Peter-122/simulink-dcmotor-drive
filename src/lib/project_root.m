function root = project_root()
%PROJECT_ROOT  Absolute path of the project folder.
root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
end
