function symbols = qam16_mod(bits)
    bits = reshape(bits, 4, []).';
    mapping = reshape(-3:2:3, 4, 1) + 1j * reshape(-3:2:3, 1, 4);
    mapping = mapping(:) / sqrt(10);
    symbols = mapping(bi2de(bits, 'left-msb') + 1);
end
