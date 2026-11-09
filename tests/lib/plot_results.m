function plot_results(traces, labels, ctrl, file)
%PLOT_RESULTS  Speed, current and voltage of all scenarios in one figure.
short = cellfun(@(s) strtok(s), labels, 'UniformOutput', false);   % 'S1', 'S2', ...
fig = figure('Visible', 'off', 'Position', [100 100 1000 850]);

subplot(3, 1, 1); hold on; grid on;
for k = 1:numel(traces), plot(traces{k}.t, traces{k}.w, 'LineWidth', 1.3); end
for k = 1:numel(traces), plot(traces{k}.t, traces{k}.wr, ':k', 'HandleVisibility', 'off'); end
ylabel('\omega [rad/s]'); title('Speed (dotted: reference)'); legend(short, 'Location', 'southeast');

subplot(3, 1, 2); hold on; grid on;
for k = 1:numel(traces), plot(traces{k}.t, traces{k}.I, 'LineWidth', 1.3); end
if isfield(ctrl, 'Imax'), yline([ctrl.Imax -ctrl.Imax], ':r', 'HandleVisibility', 'off'); end
ylabel('i [A]'); title('Armature current'); legend(short);

subplot(3, 1, 3); hold on; grid on;
for k = 1:numel(traces), stairs(traces{k}.tV, traces{k}.V, 'LineWidth', 1.3); end
yline(ctrl.Vmax, ':r', 'HandleVisibility', 'off');
ylabel('V [V]'); xlabel('t [s]'); title('Armature voltage'); legend(short);

exportgraphics(fig, file, 'Resolution', 120);
close(fig);
end
