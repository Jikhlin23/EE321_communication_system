function symbols = psk8_mod(bits)
    bits = reshape(bits, 3, []).';
    mapping = exp(1j * (0:7) * pi/4);
    symbols = mapping(bi2de(bits, 'left-msb') + 1);
end
