clear all;
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
    plot(t, signals(i, :));
    title(titles(i));
end
xlabel('Time (min)');