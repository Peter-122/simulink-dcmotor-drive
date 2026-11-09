%RUN_ALL  Rebuild all three models from scratch and run every test suite.
%   Reports and plots are written to results/.

startup_project;

build_pid_model;
build_cascade_model;
build_drive_model;

results_pid     = test_pid;
results_cascade = test_cascade;
results_drive   = test_drive;

fprintf('\nSummary: v0.1 %d/%d   v0.2 %d/%d   v0.3 %d/%d checks passed\n', ...
    sum(results_pid.Pass),     height(results_pid), ...
    sum(results_cascade.Pass), height(results_cascade), ...
    sum(results_drive.Pass),   height(results_drive));
