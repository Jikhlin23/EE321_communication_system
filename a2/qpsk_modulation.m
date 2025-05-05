% Function for QPSK modulation
function symbols = qpsk_modulation(bits)
    % Reshape bit sequence into pairs for QPSK mapping
    bits_reshaped = reshape(bits, 2, []).';
    
    % Define QPSK constellation mapping
    mapping = [1+1j, -1+1j, 1-1j, -1-1j] / sqrt(2); % Normalized QPSK symbols
    
    % Convert bit pairs to symbols
    symbols = mapping(bi2de(bits_reshaped, 'left-msb') + 1);
end