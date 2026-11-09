function add_pi_loop(sys, refName, fbName, outName, piName, P, I, limit, Ts)
%ADD_PI_LOOP  Fill a subsystem with: error = ref - feedback -> PI -> output.
clear_subsystem(sys);
add_block('simulink/Sources/In1', [sys '/' refName], 'Position', [30 43 60 57]);
add_block('simulink/Sources/In1', [sys '/' fbName],  'Position', [30 103 60 117]);
add_block('simulink/Math Operations/Sum', [sys '/Error'], 'Inputs', '+-', ...
    'IconShape', 'round', 'Position', [110 40 130 60]);
add_pi_block(sys, piName, P, I, limit, Ts, [180 30 260 70]);
add_block('simulink/Sinks/Out1', [sys '/' outName], 'Position', [310 43 340 57]);
wire(sys, [refName '/1'], 'Error/1', ...
             [fbName '/1'],  'Error/2', ...
             'Error/1',      [piName '/1'], ...
             [piName '/1'],  [outName '/1']);
end
