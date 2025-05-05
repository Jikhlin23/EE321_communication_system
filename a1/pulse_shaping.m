function shaped_signal = pulse_shaping(symbols, rc_pulse, sps)
    upsampled = upsample(symbols, sps);
    shaped_signal = conv(upsampled, rc_pulse, 'same');
end
