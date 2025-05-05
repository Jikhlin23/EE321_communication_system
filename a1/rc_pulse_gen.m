function rc_pulse = rc_pulse_gen(sps, span, rolloff)
    t = (-span*sps:span*sps) / sps;
    rc_pulse = sinc(t) .* cos(pi * rolloff * t) ./ (1 - (2 * rolloff * t).^2);
    rc_pulse(isnan(rc_pulse)) = sinc(1 / (2 * rolloff));
end
