function name_signal(sys, blockName, port, signalName)
%NAME_SIGNAL  Label the line leaving a block's output port.
ports = get_param([sys '/' blockName], 'PortHandles');
set_param(ports.Outport(port), 'Name', signalName);
end
