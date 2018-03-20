function Hd = alpha
%ALPHA Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.3 and Signal Processing Toolbox 7.5.
% Generated on: 20-Mar-2018 20:57:26

% FIR Window Bandpass filter designed using the FIR1 function.

% All frequency values are in Hz.
Fs = 200;  % Sampling Frequency

N    = 800;      % Order
Fc1  = 8;        % First Cutoff Frequency
Fc2  = 12;       % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hamming(N+1);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd = dfilt.dffir(b);

% [EOF]