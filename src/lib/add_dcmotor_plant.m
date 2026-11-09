function add_dcmotor_plant(sys)
%ADD_DCMOTOR_PLANT  Fill a subsystem with the DC motor equations.
%   Inputs : V (armature voltage), TL (load torque)
%   Outputs: w (speed), i (armature current)
%
%     L di/dt = V - R*i - K*w
%     J dw/dt = K*i - b*w - TL

clear_subsystem(sys);
add_block('simulink/Sources/In1', [sys '/V'],  'Position', [20 63 50 77]);
add_block('simulink/Sources/In1', [sys '/TL'], 'Position', [300 203 330 217]);

% Electrical side
add_block('simulink/Math Operations/Sum',  [sys '/Electrical'], 'Inputs', '+--', 'Position', [90 50 110 90]);
add_block('simulink/Math Operations/Gain', [sys '/invL'], 'Gain', '1/motor.L', 'Position', [140 55 180 85]);
add_block('simulink/Continuous/Integrator', [sys '/Current'], 'InitialCondition', 'motor.i0', 'Position', [210 55 240 85]);
add_block('simulink/Math Operations/Gain', [sys '/R'],  'Gain', 'motor.R', 'Orientation', 'left', 'Position', [140 115 180 145]);
add_block('simulink/Math Operations/Gain', [sys '/Ke'], 'Gain', 'motor.K', 'Orientation', 'left', 'Position', [300 145 340 175]);

% Mechanical side
add_block('simulink/Math Operations/Gain', [sys '/Kt'], 'Gain', 'motor.K', 'Position', [290 55 330 85]);
add_block('simulink/Math Operations/Sum',  [sys '/Mechanical'], 'Inputs', '+--', 'Position', [370 50 390 90]);
add_block('simulink/Math Operations/Gain', [sys '/invJ'], 'Gain', '1/motor.J', 'Position', [420 55 460 85]);
add_block('simulink/Continuous/Integrator', [sys '/Speed'], 'InitialCondition', 'motor.w0', 'Position', [490 55 520 85]);
add_block('simulink/Math Operations/Gain', [sys '/b'], 'Gain', 'motor.b', 'Orientation', 'left', 'Position', [420 115 460 145]);

add_block('simulink/Sinks/Out1', [sys '/w'], 'Position', [590 63 620 77]);
add_block('simulink/Sinks/Out1', [sys '/i'], 'Position', [590 243 620 257]);

wire(sys, 'V/1', 'Electrical/1',   'Electrical/1', 'invL/1',   'invL/1', 'Current/1', ...
             'Current/1', 'R/1',      'R/1', 'Electrical/2',      'Ke/1', 'Electrical/3', ...
             'Current/1', 'Kt/1',     'Current/1', 'i/1', ...
             'Kt/1', 'Mechanical/1',  'b/1', 'Mechanical/2',      'TL/1', 'Mechanical/3', ...
             'Mechanical/1', 'invJ/1', 'invJ/1', 'Speed/1', ...
             'Speed/1', 'w/1',        'Speed/1', 'b/1',           'Speed/1', 'Ke/1');
Simulink.BlockDiagram.arrangeSystem(sys);
end
