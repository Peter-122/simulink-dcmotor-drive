%CASCADE_PARAMS  v0.2 parameters: cascade speed/current control.
%   Loads motor_params.m and adds the two controller loops.

motor_params;

%% Inner current loop: PI tuned by cancelling the L/R pole
%  bandwidth wc = 1000 rad/s  ->  Kp = wc*L,  Ki = wc*R
ctrl.Kp_i = 5;        % [V/A]
ctrl.Ki_i = 1000;     % [V/(A*s)]
ctrl.Ts_i = 1e-4;     % sample time, 10 kHz              [s]

%% Outer speed loop: PI, output is the current reference
%  bandwidth wc = 100 rad/s  ->  Kp = wc*J/K,  integral zero at wc/5
ctrl.Kp_w = 0.2;      % [A/(rad/s)]
ctrl.Ki_w = 4;        % [A/rad]
ctrl.Ts_w = 1e-3;     % sample time, 1 kHz               [s]

ctrl.Imax = 5;        % current limit (driver rating)    [A]

%% Acceptance limits (added / changed)
req.settling_s  = 0.30;   % large steps are current-limited  [s]
req.Imax_margin = 1.05;   % |i| must stay below 1.05*Imax
