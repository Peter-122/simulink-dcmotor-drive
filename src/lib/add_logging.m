function add_logging(mdl, sources, x, y)
%ADD_LOGGING  Add one To Workspace block (timeseries) per signal.
%   sources: N x 2 cell {variableName, 'Block/port'}
for k = 1:size(sources, 1)
    name = sources{k, 1};
    top  = y + 40*(k-1);
    add_block('simulink/Sinks/To Workspace', [mdl '/' name], ...
        'VariableName', name, 'SaveFormat', 'Timeseries', ...
        'Position', [x top x+80 top+25]);
    add_line(mdl, sources{k, 2}, [name '/1'], 'autorouting', 'on');
end
end
