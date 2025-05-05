% Clear workspace, cmd window
clear all;
clc;

%% PARAMS
Ts = 1e-6;          % Sym time = 1 µs
pLen = 16;          % Pilot bits
dLen = 584;         % Data bits
phi = deg2rad(30);  % Phase offset rad
df = 1e4;           % Freq offset Hz
% Calc freq offset rad/sym
w = 2 * pi * df;
Gamma = w * Ts;
K = (pLen + dLen) / 2;  % Total QPSK syms = 300

%% GEN PILOT, DATA, QPSK MOD
p = randi([0 1], pLen, 1);  % Rand pilot bits
d = randi([0 1], dLen, 1);   % Rand data bits
% QPSK mod fn: bits -> syms
qpsk = @(b) (1/sqrt(2)) * ( (1 - 2*b(1:2:end)) + 1j*(1 - 2*b(2:2:end)) );
pSym = qpsk(p);    % Mod pilot
dSym = qpsk(d);    % Mod data
x = [pSym; dSym];  % Concat syms
k = (1:K).';       % Sym idx

%% ADD OFFSET, NOISE @ SNR=30dB
% Apply freq, phase offset
tmp = Gamma * k + phi;
y0 = x .* exp(1j * tmp);
snrDb = 30;        % SNR dB
snr = 10^(snrDb/10);  % SNR linear
nPwr = 1 / snr;    % Noise pwr
% Gen complex noise
n = sqrt(nPwr/2) * (randn(K,1) + 1j*randn(K,1));
y = y0 + n;        % Noisy sig

% Plot rx constellation
figure;
scatter(real(y), imag(y), 'filled');
title('Received Constellation with Frequency and Phase Offset');
xlabel('In-Phase');
ylabel('Quadrature');
grid on;

%% ML EST FREQ, PHASE
pRx = y(1:8);      % First 8 rx pilot syms
pTx = x(1:8);      % First 8 tx pilot syms
ang = angle(pRx .* conj(pTx));  % Phase diff
A = [k(1:8), ones(8,1)];       % Design mtx
est = A \ ang;     % Solve LS
wHat = est(1);     % Est freq offset
phiHat = est(2);   % Est phase offset

%% COMPENSATE OFFSET
% Remove est offsets
tmp = wHat * k + phiHat;
yComp = y .* exp(-1j * tmp);

% Plot comp constellation
figure;
scatter(real(yComp), imag(yComp), 'filled');
title('Compensated Constellation');
xlabel('In-Phase');
ylabel('Quadrature');
grid on;

%% TEST SNR 10-30dB, STEP=5
snrVals = 10:5:30;  % SNR range
wEst = zeros(size(snrVals));  % Freq est store
phiEst = zeros(size(snrVals)); % Phase est store

for i = 1:length(snrVals)
    % Gen noisy sig for SNR
    snr = 10^(snrVals(i)/10);
    nPwr = 1 / snr;
    n = sqrt(nPwr/2) * (randn(K,1) + 1j*randn(K,1));
    y = y0 + n;

    % Est offsets
    pRx = y(1:8);
    ang = angle(pRx .* conj(pTx));
    est = A \ ang;
    wEst(i) = est(1);
    phiEst(i) = est(2);

    % Compensate
    tmp = est(1) * k + est(2);
    yComp = y .* exp(-1j * tmp);

    % Plot comp constellation
    figure;
    scatter(real(yComp), imag(yComp), 'filled');
    title(sprintf('Constellation after Compensation (SNR = %d dB)', snrVals(i)));
    xlabel('In-Phase');
    ylabel('Quadrature');
    grid on;
end

%% SHOW RESULTS
% Convert est to Hz, deg
dfEst = wEst / (2*pi*Ts);
phiDeg = rad2deg(phiEst);

% Print table
fprintf('\nSNR(dB) | df Est(Hz) | phi Est(deg)\n');
fprintf('---------------------------------\n');
for i = 1:length(snrVals)
    fprintf('%2d | %10.2f | %10.2f\n', snrVals(i), dfEst(i), phiDeg(i));
end