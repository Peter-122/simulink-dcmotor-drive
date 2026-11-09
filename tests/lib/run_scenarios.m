function results = run_scenarios(cfg)
%RUN_SCENARIOS  Simulate a model in several scenarios and check pass/fail limits.
%
%   cfg.model     model name (in models/)
%   cfg.build     function handle that builds the model if it is missing
%   cfg.params    name of the parameter script the model uses
%   cfg.title     report heading
%   cfg.scenarios N x 2 cell {label, {'field', value, ...}}
%   cfg.checks    M x 4 cell {label, metric, limitExpression, 'max' | 'min'}
%   cfg.output    file prefix for results/<output>_report.txt and _plot.png
%   cfg.extra     (optional) function handle @(out) printing extra report lines
%
%   Returns a table with one row per scenario and check.

resultsDir = fullfile(project_root, 'results');
fid = fopen(fullfile(resultsDir, [cfg.output '_report.txt']), 'w');
cleanup = onCleanup(@() finish(fid));
out = @(varargin) log_line(fid, varargin{:});

out('%s  |  %s  |  MATLAB %s\n', cfg.title, char(datetime('now')), version);
out('%s\n', repmat('=', 1, 78));
results = table();
traces  = cell(size(cfg.scenarios, 1), 1);

try
    modelFile = fullfile(project_root, 'models', [cfg.model '.slx']);
    if ~isfile(modelFile)
        out('Model not found, building it first.\n');
        cfg.build();
    end
    load_system(modelFile);

    for s = 1:size(cfg.scenarios, 1)
        % Overrides go to the model through apply_scenario.m (InitFcn)
        scenario.overrides = reshape(cfg.scenarios{s, 2}, 2, []).';
        assignin('base', 'active_scenario', scenario);

        % Load the same parameter values locally for the checks
        eval(cfg.params);
        for k = 1:size(scenario.overrides, 1)
            eval(sprintf('%s = %s;', scenario.overrides{k, 1}, mat2str(scenario.overrides{k, 2})));
        end

        simOut    = sim(cfg.model);
        m         = speed_metrics(simOut, scn, ctrl);
        traces{s} = m.trace;

        out('\n%s\n', cfg.scenarios{s, 1});
        out('  %-26s %10s %11s  %s\n', 'Check', 'Value', 'Limit', 'Result');
        for c = 1:size(cfg.checks, 1)
            [label, metric, limitExpr, kind] = cfg.checks{c, :};
            value = m.(metric);
            limit = eval(limitExpr);
            if strcmp(kind, 'min')
                pass = value >= limit;  op = '>';
            else
                pass = value <= limit + 1e-9;  op = '<';
            end
            out('  %-26s %10.4f %s %9.4f  %s\n', label, value, op, limit, pass_fail(pass));
            results = [results; table(string(cfg.scenarios{s, 1}), string(label), ...
                value, limit, pass, 'VariableNames', {'Scenario', 'Check', 'Value', 'Limit', 'Pass'})]; %#ok<AGROW>
        end
    end

    out('\n%s\nOVERALL: %s (%d/%d checks)\n', repmat('=', 1, 78), ...
        pass_fail(all(results.Pass)), sum(results.Pass), height(results));

    if isfield(cfg, 'extra'), cfg.extra(out); end

    eval(cfg.params);   % nominal values for the plot limit lines
    plot_results(traces, cfg.scenarios(:, 1), ctrl, fullfile(resultsDir, [cfg.output '_plot.png']));
    out('\nPlot saved: results/%s_plot.png\n', cfg.output);
catch err
    out('\nERROR: %s\n', err.message);
    for k = 1:numel(err.stack)
        out('  at %s (line %d)\n', err.stack(k).name, err.stack(k).line);
    end
    for k = 1:numel(err.cause)
        out('  cause: %s\n', err.cause{k}.message);
    end
end
end

function finish(fid)
fclose(fid);
evalin('base', 'clear active_scenario');
end

function text = pass_fail(ok)
if ok, text = 'PASS'; else, text = 'FAIL'; end
end
