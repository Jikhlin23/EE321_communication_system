
% Function to generate SRRC pulse
function pulse = generate_srrc_pulse(beta, span, sps)
    % Define time vector
    t = (-span*sps:span*sps) / sps;
    
    % Compute SRRC pulse values using standard formula
    pulse = (sin(pi*t*(1-beta)) + 4*beta*t.*cos(pi*t*(1+beta))) ./ ...
        (pi*t.*(1-(4*beta*t).^2));
    
    % Handle special cases to avoid division by zero
    pulse(t == 0) = (1 - beta + 4*beta/pi);
    pulse(abs(4*beta*t) == 1) = beta/sqrt(2) * ((1+2/pi) * sin(pi/(4*beta)) + (1-2/pi) * cos(pi/(4*beta)));
    
    % Normalize pulse energy
    pulse = pulse / sqrt(sum(pulse.^2));
end