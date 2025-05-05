% Function for transmit pulse shaping
function tx_signal = transmit_pulse_shaping(symbols, pulse, sps)
    % Upsample QPSK symbols by inserting zeros
    upsampled_symbols = upsample(symbols, sps);
    
    % Convolve upsampled symbols with SRRC pulse to shape the signal
    tx_signal = conv(upsampled_symbols, pulse, 'same');
end