%DRIVE_PARAMS  v0.3 parameters: reference ramp and acceleration feedforward.
%   Loads cascade_params.m and adds reference shaping.

cascade_params;

%% Reference shaping
ctrl.w_slew = 1500;   % ramp rate, below the 2500 rad/s^2 the 5 A limit allows  [rad/s^2]
scn.t_ref   = 0.01;   % setpoint step time                                       [s]
% The setpoint must step after t = 0: a Rate Limiter passes its input
% through unchanged at the first time step, which would bypass the ramp.

%% Acceleration feedforward:  i_ff = J_nom * d(w_ref)/dt / K
ctrl.J_nom = 1e-4;    % inertia assumed by the feedforward  [kg*m^2]
% Kept fixed on purpose: test scenarios that change motor.J check the
% controller's robustness to inertia mismatch.

%% Acceptance limits (added / changed)
req.settling_s   = 0.10;  % 2 % band, measured from the end of the ramp  [s]
req.track_pct    = 5;     % max |w - w_ref| during the ramp             [% of setpoint]
req.sat_time_s   = 0.05;  % total time the voltage sits at its limit    [s]
req.headroom_pct = 1;     % steady-state voltage margin                 [% of Vmax]
