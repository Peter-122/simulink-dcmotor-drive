function results = test_drive()
%TEST_DRIVE  v0.3 tests: ramp + feedforward drive in four scenarios,
%   plus the load-capability table. The feedforward always uses the
%   nominal inertia, so S3/S4 test robustness to inertia mismatch.
cfg.model     = 'dcmotor_drive';
cfg.build     = @build_drive_model;
cfg.params    = 'drive_params';
cfg.title     = 'dcmotor_drive v0.3 test report';
cfg.output    = 'drive';
cfg.extra     = @print_load_capability;
cfg.scenarios = {
    'S1 nominal (200 rad/s, load at 1 s)', {}
    'S2 high speed (450 rad/s)',           {'scn.w_ref', 450}
    'S3 heavy inertia (J x1.5)',           {'motor.J', 1.5e-4}
    'S4 light inertia (J x0.5)',           {'motor.J', 0.5e-4}};
cfg.checks = {
    'Overshoot [%]',             'overshoot', 'req.overshoot_pct',          'max'
    'Settling after ramp [s]',   'settling',  'req.settling_s',             'max'
    'Ramp tracking error [%]',   'tracking',  'req.track_pct',              'max'
    'Steady-state error [%]',    'ss_error',  'req.ss_error_pct',           'max'
    'Load speed dip [%]',        'dip',       'req.dip_pct',                'max'
    'Load recovery [s]',         'recovery',  'req.recovery_s',             'max'
    'Peak current [A]',          'i_peak',    'req.Imax_margin*ctrl.Imax',  'max'
    'Peak voltage [V]',          'v_peak',    'ctrl.Vmax',                  'max'
    'Time at voltage limit [s]', 'sat_time',  'req.sat_time_s',             'max'
    'Voltage headroom [%]',      'headroom',  'req.headroom_pct',           'min'};
results = run_scenarios(cfg);
end
