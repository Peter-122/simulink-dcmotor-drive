%MOTOR_PARAMS  Motor data, test scenario and base acceptance limits.
%   Single source of the motor values. All models and tests read these
%   structs; Simulink blocks reference the fields by name (motor.R, ...).

%% Motor: small 24 V permanent-magnet DC motor
motor.R  = 1.0;       % armature resistance          [Ohm]
motor.L  = 5e-3;      % armature inductance          [H]
motor.K  = 0.05;      % torque / back-EMF constant   [N*m/A] = [V*s/rad]
motor.J  = 1e-4;      % rotor + load inertia         [kg*m^2]
motor.b  = 1e-5;      % viscous friction             [N*m*s/rad]
motor.i0 = 0;         % initial current              [A]
motor.w0 = 0;         % initial speed                [rad/s]

%% v0.1 speed controller: PI, voltage output
ctrl.Kp   = 0.1;      % proportional gain            [V/(rad/s)]
ctrl.Ki   = 2.5;      % integral gain                [V/rad]
ctrl.Vmax = 24;       % supply voltage               [V]

%% Test scenario
scn.w_ref  = 200;     % speed setpoint               [rad/s]
scn.t_ref  = 0;       % setpoint step time           [s]
scn.TL     = 0.05;    % load torque step             [N*m]
scn.t_load = 1.0;     % load step time               [s]
scn.t_stop = 2.0;     % simulation stop time         [s]

%% Acceptance limits
req.overshoot_pct = 5;     % max overshoot            [%]
req.settling_s    = 0.20;  % 2 % settling time        [s]
req.ss_error_pct  = 0.5;   % steady-state error       [%]
req.dip_pct       = 5;     % max speed dip on load    [%]
req.recovery_s    = 0.20;  % back inside 2 % band     [s]
