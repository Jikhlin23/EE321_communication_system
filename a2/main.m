% Main script: main.m
clc; clear; close all; % Clear workspace, close figures, and reset command window

% Generate bit sequence
num_bits = 600; % Number of bits to be transmitted
bits = randi([0, 1], 1, num_bits); % Generate random bit sequence of 0s and 1s

% QPSK modulation
symbols = qpsk_modulation(bits); % Convert bit sequence to QPSK symbols

% Generate SRRC pulse
span = 6; % Span in symbols (determines pulse truncation)
sps = 12; % Samples per symbol (upsampling factor)
roll_off = 0.3; % Roll-off factor for SRRC pulse
srrc_pulse = generate_srrc(roll_off, span, sps); % Generate SRRC pulse

% Transmit pulse shaping
tx_signal = transmit_pulse_shaping(symbols, srrc_pulse, sps); % Apply pulse shaping

% Add AWGN noise and matched filtering at different SNR values
snr_values = [6, 8, 10]; % Define SNR values to evaluate system performance
for snr = snr_values
    % Add complex AWGN noise
    rx_signal = awgn(tx_signal, snr, 'measured'); % Add noise to transmitted signal
    
    % Receive matched filtering and downsampling
    rx_symbols = receive_matched_filtering(rx_signal, srrc_pulse, sps); % Apply matched filtering
    
    % Plot received constellation
    figure; scatter(real(rx_symbols), imag(rx_symbols), 'b.'); % Plot constellation
    title(['Received Constellation at SNR = ', num2str(snr), ' dB']); % Set title
    xlabel('In-Phase'); ylabel('Quadrature'); % Label axes
    axis([-1 1 -1 1]); grid on; % Ensure equal scaling and enable grid
end





