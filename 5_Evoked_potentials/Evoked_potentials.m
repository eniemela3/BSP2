clear;
close all;

%% 1

load('521282S_data_5.mat');
t = (0:1 / data_samples.Fs:(length(data_samples.raw_data) - 1) / data_samples.Fs) * 1000 ; % ms
data_to_plot = data_samples.raw_data * data_samples.amplitude_unit * 1000000; % µV

figure('Name', 'Evoked potential');
plot(t, data_to_plot, 'k', t, mean(data_to_plot), 'r');
hold on;
xlabel('Time (ms)');
ylabel('Voltage (mV)');
title('Raw data and average');

%% 2

variances = var(data_to_plot, 1, 1);
variance = mean(variances);
energy = mean(mean(data_to_plot).^ 2);
SNR = 10 * log10(energy / variance);
SNR_improvement = 20 * log10(sqrt(size(data_to_plot, 1)));
new_SNR = SNR + SNR_improvement;

%% 3

chirp = chirp_features(data_samples);
plot(t, chirp.fitted_chirp);
line([chirp.fit_delay chirp.fit_delay] * 1000, ylim, 'Color','black','LineStyle','--');
line([chirp.fit_first_peak_location chirp.fit_first_peak_location] * 1000, ylim, 'Color','black','LineStyle','--');
line([chirp.fit_second_peak_location chirp.fit_second_peak_location] * 1000, ylim, 'Color','black','LineStyle','--');
line(xlim, [chirp.fit_first_peak_amplitude chirp.fit_first_peak_amplitude], 'Color','yellow','LineStyle','--');
line(xlim, [-chirp.fit_second_peak_amplitude -chirp.fit_second_peak_amplitude], 'Color','yellow','LineStyle','--');
