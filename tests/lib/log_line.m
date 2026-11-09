function log_line(fid, varargin)
%LOG_LINE  Print to the Command Window and to an open report file.
fprintf(varargin{:});
fprintf(fid, varargin{:});
end
