function m = speed_metrics(simOut, scn, ctrl)
%SPEED_METRICS  Performance figures of one speed-drive simulation.
%   All percentages are relative to the speed setpoint scn.w_ref.
%   Settling is measured from the moment the reference reaches the setpoint
%   (the end of the ramp when ctrl.w_slew exists, otherwise the step time).

t  = simOut.w_log.Time;   w = squeeze(simOut.w_log.Data);
I  = squeeze(simOut.i_log.Data);
tV = simOut.V_log.Time;   V = squeeze(simOut.V_log.Data);   % discrete blocks log on their own time base
wr = resample_to(simOut.w_ref_log.Time, squeeze(simOut.w_ref_log.Data), t);

r    = scn.w_ref;
band = 0.02 * r;
tRef = scn.t_ref;
if isfield(ctrl, 'w_slew'), tRef = scn.t_ref + r / ctrl.w_slew; end

before = t < scn.t_load;
after  = ~before;

m.overshoot = max(0, (max(w(before)) - r) / r * 100);
m.settling  = last_exit(t, before & abs(w - r) > band, tRef);
m.ss_error  = abs(r - resample_to(t, w, scn.t_load - 1e-3)) / r * 100;
m.dip       = (r - min(w(after))) / r * 100;
m.recovery  = last_exit(t, after & abs(w - r) > band, scn.t_load);
m.i_peak    = max(abs(I));
m.v_peak    = max(abs(V));

ramp       = t < tRef;
m.tracking = 0;
if any(ramp), m.tracking = max(abs(w(ramp) - wr(ramp))) / r * 100; end

dt         = [diff(tV); 0];
m.sat_time = sum(dt(abs(V) >= ctrl.Vmax - 1e-6));
m.headroom = (ctrl.Vmax - abs(V(end))) / ctrl.Vmax * 100;

m.trace = struct('t', t, 'w', w, 'wr', wr, 'I', I, 'tV', tV, 'V', V);
end

function d = last_exit(t, outside, t0)
% Time after t0 at which the signal last left the band (0 if it never did).
k = find(outside, 1, 'last');
d = 0;
if ~isempty(k), d = max(0, t(k) - t0); end
end

function y = resample_to(tx, x, tq)
% Interpolate, tolerating repeated time stamps from the solver.
[tx, keep] = unique(tx);
y = interp1(tx, x(keep), tq);
end
