function wire(sys, varargin)
%WIRE  Draw signal lines in pairs: wire(sys, 'A/1','B/1', 'B/1','C/1', ...)
for k = 1:2:numel(varargin)
    add_line(sys, varargin{k}, varargin{k+1}, 'autorouting', 'on');
end
end
