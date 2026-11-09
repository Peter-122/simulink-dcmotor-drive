function add_note(mdl, text, position)
%ADD_NOTE  Add a text annotation at [x y] on the top level of a model.
%   Cosmetic only, so a failure never stops a build.
try
    add_block('built-in/Note', [mdl '/' text], 'Position', position);
catch
end
end
