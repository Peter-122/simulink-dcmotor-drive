function results = test_pid()
%TEST_PID  v0.1 tests: single PI loop, nominal scenario.
cfg.model     = 'dcmotor_pid';
cfg.build     = @build_pid_model;
cfg.params    = 'motor_params';
cfg.title     = 'dcmotor_pid v0.1 test report';
cfg.output    = 'pid';
cfg.scenarios = {'S1 nominal (200 rad/s, load at 1 s)', {}};
cfg.checks = {
    'Overshoot [%]',          'overshoot', 'req.overshoot_pct', 'max'
    'Settling time 2% [s]',   'settling',  'req.settling_s',    'max'
    'Steady-state error [%]', 'ss_error',  'req.ss_error_pct',  'max'
    'Load speed dip [%]',     'dip',       'req.dip_pct',       'max'
    'Load recovery [s]',      'recovery',  'req.recovery_s',    'max'
    'Peak voltage [V]',       'v_peak',    'ctrl.Vmax',         'max'};
results = run_scenarios(cfg);
end
