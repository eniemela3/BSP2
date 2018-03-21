clear;
close all;

%% 1

load('521282S_data_2.mat');

delta = filter(delta_filter(), signal);
theta = filter(theta_filter(), signal);
alpha = filter(alpha_filter(), signal);
beta = filter(beta_filter(), signal);
signals = [signal; delta; theta; alpha; beta];
titles = {'Raw EEG', 'Delta', 'Theta', 'Alpha', 'Beta'};

figure('Name', 'Raw EEG signals');

for i = 1:size(signals, 1)
    subplot(size(signals, 1), 1, i);
    [upper, lower] = envelope(signals(i, :), Fs*30, 'rms');
    plot(t, signals(i, :), t, upper, 'r', t, lower, 'r');
    title(titles(i));
    set(gca,'ylim',[-0.03 0.03]);
    set(gca,'xlim',[t(1) t(length(t))]);
end
xlabel('Time (min)');

%% 2

[S, F, T, P] = spectrogram(signal, Fs*30, Fs*29, 0.1:0.1:32, Fs);

delta_range = find(F==1):find(F==4);
theta_range = find(F==4):find(F==8);
alpha_range = find(F==8):find(F==12);
beta_range = find(F==12):find(F==32);
ranges = {delta_range; theta_range; alpha_range; beta_range};

powers = cell(size(ranges));

for i = 1:size(ranges, 1)
    powers{i} = sum(P(ranges{i}, :)) ./ sum(P(:, :));
end

T = T/60;

figure;
subplot(3, 1, 1);
imagesc(T, F, log10(P), [-7  -3]);
axis xy;
title('Power spectral density');
ylabel('f (Hz)');

subplot(3, 1, 2);
plot(T, powers{1}, T, powers{2}, T, powers{3}, T, powers{4});
legend(titles{2:length(titles)});
title('Relative powers');
set(gca,'ylim',[0 1]);
set(gca,'xlim',[T(1) T(length(T))]);

%% 3

P_normalized = P(:, :) ./ sum(P(:, :));
SE = [];
bins = length(0.1:0.1:32);

for i = 1:size(P_normalized, 2)
    SE(i) = -sum(P_normalized(:, i) .* log2(P_normalized(:, i))) / log2(bins);
end

subplot(3, 1, 3);
plot(T, SE);
title('Spectral entropy');
set(gca,'xlim',[T(1) T(length(T))]);
xlabel('Time (min)');