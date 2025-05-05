
%% main.m
clc; clear; close all;

% Generate a 600-bit random bit sequence
bit_seq = randi([0 1], 1, 600);

% Perform modulation using different schemes
qpsk_symbols = qpsk_mod(bit_seq);  % QPSK modulation
psk8_symbols = psk8_mod(bit_seq);  % 8PSK modulation
qam16_symbols = qam16_mod(bit_seq); % 16QAM modulation

% Plot constellation diagrams for each modulation scheme
figure; scatter(real(qpsk_symbols), imag(qpsk_symbols), 'filled');
title('QPSK Constellation'); grid on;
figure; scatter(real(psk8_symbols), imag(psk8_symbols), 'filled');
title('8PSK Constellation'); grid on;
figure; scatter(real(qam16_symbols), imag(qam16_symbols), 'filled');
title('16QAM Constellation'); grid on;

% Generate Raised Cosine pulse with roll-off factor 0.35, 12 samples per symbol, and span of 6 symbols
rc_pulse = rc_pulse_gen(12, 6, 0.35);

% Apply pulse shaping by upsampling and convolving with the RC pulse
qpsk_shaped = pulse_shaping(qpsk_symbols, rc_pulse, 12);
psk8_shaped = pulse_shaping(psk8_symbols, rc_pulse, 12);
qam16_shaped = pulse_shaping(qam16_symbols, rc_pulse, 12);

% Plot the pulse-shaped signals
figure; plot(real(qpsk_shaped));
title('QPSK with RC Pulse Shaping'); grid on;
figure; plot(real(psk8_shaped));
title('8PSK with RC Pulse Shaping'); grid on;
figure; plot(real(qam16_shaped));
title('16QAM with RC Pulse Shaping'); grid on;

