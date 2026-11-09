function results = test_cascade()
%TEST_CASCADE  v0.2 tests: cascade drive in four scenarios.
cfg.model     = 'dcmotor_cascade';
cfg.build     = @build_cascade_model;
cfg.params    = 'cascade_params';
cfg.title     = 'dcmotor_cascade v0.2 test report';
cfg.output    = 'cascade';
cfg.scenarios = {
    'S1 nominal (200 rad/s, load at 1 s)', {}
    'S2 large step (450 rad/s)',           {'scn.w_ref', 450}
    'S3 heavy inertia (J x1.5)',           {'motor.J', 1.5e-4}
    'S4 light inertia (J x0.5)',           {'motor.J', 0.5e-4}};
cfg.checks = {
    'Overshoot [%]',          'overshoot', 'req.overshoot_pct',          'max'
    'Settling time 2% [s]',   'settling',  'req.settling_s',             'max'
    'Steady-state error [%]', 'ss_error',  'req.ss_error_pct',           'max'
    'Load speed dip [%]',     'dip',       'req.dip_pct',                'max'
    'Load recovery [s]',      'recovery',  'req.recovery_s',             'max'
    'Peak current [A]',       'i_peak',    'req.Imax_margin*ctrl.Imax',  'max'
    'Peak voltage [V]',       'v_peak',    'ctrl.Vmax',                  'max'};
results = run_scenarios(cfg);
end
