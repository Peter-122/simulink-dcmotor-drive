function print_load_capability(out)
%PRINT_LOAD_CAPABILITY  Maximum steady load torque the drive can hold vs speed.
%   Limited either by the current limit or by the voltage left after back-EMF.
drive_params;
out('\nLoad capability (steady state, Vmax = %g V, Imax = %g A)\n', ctrl.Vmax, ctrl.Imax);
out('  %-12s %-14s %s\n', 'Speed', 'Max load', 'Limited by');
for w = [100 200 300 400 450]
    iVoltage = (ctrl.Vmax - motor.K * w) / motor.R;
    [iMax, limitIdx] = min([ctrl.Imax, iVoltage]);
    limits = {'current', 'voltage'};
    out('  %-12s %-14s %s\n', sprintf('%d rad/s', w), ...
        sprintf('%.4f N*m', motor.K * iMax - motor.b * w), limits{limitIdx});
end
end
