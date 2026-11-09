function clear_subsystem(sys)
%CLEAR_SUBSYSTEM  Remove the default In1 -> Out1 contents of a new subsystem.
delete_line(sys, 'In1/1', 'Out1/1');
delete_block([sys '/In1']);
delete_block([sys '/Out1']);
end
