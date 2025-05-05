
% Function for receive matched filtering and downsampling
function rx_symbols = receive_matched_filtering(rx_signal, pulse, sps)
    % Apply matched filtering using convolution with SRRC pulse
    rx_filtered = conv(rx_signal, pulse, 'same');
    
    % Determine optimal sampling index (manual selection or peak detection)
    start_idx = sps * 6 + 1; % Adjust as necessary based on constellation visualization
    
    % Downsample to get one sample per symbol
    rx_symbols = rx_filtered(start_idx:sps:end);
end
