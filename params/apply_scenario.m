%APPLY_SCENARIO  Apply test-scenario overrides. Runs from each model's InitFcn.
%   The test runner places "active_scenario" in the base workspace, e.g.
%   active_scenario.overrides = {'scn.w_ref', 450; 'motor.J', 1.5e-4}.
%   When a model is run by hand, the variable does not exist and nothing changes.

if exist('active_scenario', 'var') && ~isempty(active_scenario)
    for override_idx = 1:size(active_scenario.overrides, 1)
        eval(sprintf('%s = %s;', active_scenario.overrides{override_idx, 1}, ...
            mat2str(active_scenario.overrides{override_idx, 2})));
    end
    clear override_idx
end
