function build_pid_model()
%BUILD_PID_MODEL  v0.1: single PI speed loop driving the motor voltage.
%   Creates models/dcmotor_pid.slx (overwrites it). Parameters: motor_params.m

mdl = 'dcmotor_pid';
motor_params;
new_model(mdl);

%% Blocks
add_block('simulink/Sources/Step', [mdl '/Speed Ref'], 'Time', 'scn.t_ref', ...
    'Before', '0', 'After', 'scn.w_ref', 'Position', [40 95 80 135]);
add_block('simulink/Sources/Step', [mdl '/Load Torque'], 'Time', 'scn.t_load', ...
    'Before', '0', 'After', 'scn.TL', 'Position', [310 175 350 215]);
add_block('simulink/Ports & Subsystems/Subsystem', [mdl '/Controller'], 'Position', [160 90 280 170]);
add_block('simulink/Ports & Subsystems/Subsystem', [mdl '/DC Motor'],   'Position', [400 90 520 210]);
add_block('simulink/Signal Routing/Mux', [mdl '/Mux'], 'Inputs', '2', 'Position', [620 60 625 120]);
add_block('simulink/Sinks/Scope', [mdl '/Scope'], 'NumInputPorts', '2', 'Position', [680 70 720 150]);

add_pi_loop([mdl '/Controller'], 'w_ref', 'w', 'V', 'Speed PI', 'ctrl.Kp', 'ctrl.Ki', 'ctrl.Vmax', '');
add_dcmotor_plant([mdl '/DC Motor']);

%% Wiring
wire(mdl, 'Speed Ref/1',   'Controller/1', ...
          'Controller/1',  'DC Motor/1', ...
          'Load Torque/1', 'DC Motor/2', ...
          'DC Motor/1',    'Controller/2', ...
          'Speed Ref/1',   'Mux/1', ...
          'DC Motor/1',    'Mux/2', ...
          'Mux/1',         'Scope/1', ...
          'Controller/1',  'Scope/2');
add_logging(mdl, {'w_ref_log', 'Speed Ref/1';  'w_log', 'DC Motor/1'; 'i_log', 'DC Motor/2'; ...
                  'V_log', 'Controller/1';    'TL_log', 'Load Torque/1'}, 680, 260);

name_signal(mdl, 'Speed Ref', 1, 'w_ref');  name_signal(mdl, 'Controller', 1, 'V');
name_signal(mdl, 'DC Motor', 1, 'w');       name_signal(mdl, 'DC Motor', 2, 'i');
name_signal(mdl, 'Load Torque', 1, 'TL');

%% Configuration
set_param(mdl, 'InitFcn', 'motor_params; apply_scenario;', ...
    'Solver', 'ode45', 'StopTime', num2str(scn.t_stop), ...
    'RelTol', '1e-6', 'MaxStep', '1e-3', 'ReturnWorkspaceOutputs', 'on', ...
    'Description', 'v0.1 DC motor speed control: PI with 24 V limit and clamping anti-windup.');
add_note(mdl, 'v0.1: PI speed loop, 24 V limit, load torque step at t = 1 s', [40 30]);
save_model(mdl);
end
