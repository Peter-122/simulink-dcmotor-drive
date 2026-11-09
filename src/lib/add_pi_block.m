function add_pi_block(sys, name, P, I, limit, Ts, position)
%ADD_PI_BLOCK  PI controller with output limit +-limit and clamping anti-windup.
%   P, I, limit, Ts are parameter expressions (e.g. 'ctrl.Kp_w').
%   Ts = '' gives a continuous-time controller.
args = {'Controller', 'PI', 'Form', 'Parallel', 'P', P, 'I', I, ...
        'LimitOutput', 'on', ...
        'UpperSaturationLimit', limit, 'LowerSaturationLimit', ['-' limit], ...
        'AntiWindupMode', 'clamping', 'Position', position};
if ~isempty(Ts)
    args = [args, {'TimeDomain', 'Discrete-time', 'SampleTime', Ts}];
end
add_block('simulink/Continuous/PID Controller', [sys '/' name], args{:});
end
