clear;
close all;

%% 1

load('521282S_data_4.mat');

figure('Name', 'Task 1');

subplot(3, 1, 1);
plot(t, signal)
set(gca,'ylim',[-1000 1000]);
set(gca,'xlim',[0 t(length(t))]);
title('Raw signal');

subplot(3, 1, 2);
[S, F, T, P] = spectrogram(signal, Fs*30, Fs*29, 0.1:0.1:32, Fs);
T = T/60;

imagesc(T, F, log10(P), [-4  6]);
axis xy;
title('Power spectral density');
ylabel('f (Hz)');
set(gca,'xlim',[0 T(length(T))]);

subplot(3, 1, 3);
P_normalized = P(:, :) ./ sum(P(:, :));
SE = [];
bins = length(0.1:0.1:32);

for i = 1:size(P_normalized, 2)
    SE(i) = -sum(P_normalized(:, i) .* log2(P_normalized(:, i))) / log2(bins);
end

plot(T, SE);
title('Spectral entropy');
set(gca,'xlim',[0 T(length(T))]);

xlabel('Time (min)');

figure;

ictal_start = 5.25 * 60 * Fs; % visually inspected

subplot(2, 1, 1);
signal1 = signal(ictal_start:ictal_start + length(t1) - 1);
plot(t1, signal1);
title('Ictal');
set(gca,'ylim',[-1000 1000]);

subplot(2, 1, 2);
signal2 = signal(1:length(t1));
plot(t1, signal2);
title('Interictal')
xlabel('Time (s)');
set(gca,'ylim',[-1000 1000]);

%% 2

start = 208 * Fs;
raw = signal(start:start + length(t2) - 1);

figure;
plot(t2, raw);
xlabel('Time (s)');
set(gca,'ylim',[-1000 1000]);
title('First ictal event');
set(gca,'xlim',[0 t2(length(t2))]);

delta = 67;

interictal1 = [1 90 * Fs];
preictal = [90 100] * Fs;
ictal = [100 132] * Fs;
postictal = [132 142] * Fs;
interictal2 = [142 * Fs length(t2) - delta];

figure('Name', '2D space');
plot([-1500 1500],[-1500 1500], '.');
hold;
plot(raw(ictal(1):ictal(2)), raw(ictal(1) + delta:ictal(2) + delta), 'cyan.');
plot(raw(preictal(1):preictal(2)), raw((preictal(1) + delta):(preictal(2) + delta)), 'black.');
plot(raw(postictal(1):postictal(2)), raw(postictal(1) + delta:(postictal(2) + delta)), 'black.');
plot(raw(interictal1(1):interictal1(2)), raw((interictal1(1) + delta):(interictal1(2) + delta)), 'red.');
plot(raw(interictal2(1):interictal2(2)), raw((interictal2(1) + delta):(interictal2(2) + delta)), 'red.')

