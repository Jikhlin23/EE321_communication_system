function symbols = qpsk_mod(bits)
    bits = reshape(bits, 2, []).';
    mapping = [1+1j, -1+1j, -1-1j, 1-1j] / sqrt(2);
    symbols = mapping(bi2de(bits, 'left-msb') + 1);
end
