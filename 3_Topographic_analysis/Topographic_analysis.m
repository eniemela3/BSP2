clear;
close all;

%% 1

figure('Name', 'Electrode locations');
topoplot([], '521282S_channel_locations.locs', 'style', 'blank', 'electrodes', 'labelpoint', 'chaninfo', '521282S_channel_locations.locs');

%% 2

data = load('521282S_data_3.mat');

for i = 1:size(data.channelNames, 1)
    [S, F, T, P] = spectrogram(data.signal(i, :), data.Fs * 30, data.Fs*29, 0.1:0.1:32, data.Fs);
    spectrograms(i) = struct('channel', data.channelNames{i}, 'S', S, 'F', F, 'T', T, 'P', P, 'power', sum(P));
end

times = [1 2*60 5*60 7*60];
figure('Name', 'Total power');
powers = zeros(size(spectrograms));

for i = 1:size(times, 2)
    for j = 1:size(spectrograms, 2)
        powers(j) = log10(spectrograms(j).power(times(i)));
    end
    subplot(size(times, 2), 1, i);
    topoplot(powers, '521282S_channel_locations.locs', 'maplimits', 'minmax');
    title(sprintf('Power at {%1.f} s', (times(i))));
end

% front_idx = [1 3 4 10];
% back_idx = [7 9 12 13]; 

figure;
plot(T, log10(spectrograms(1).power + spectrograms(3).power + spectrograms(4).power + spectrograms(10).power), ...
    T, log10(spectrograms(7).power + spectrograms(9).power + spectrograms(12).power + spectrograms(13).power));
title('Front & real power');
xlabel('Time (s)');
legend('Front', 'Rear');

%% 3

delta_range = find(F==1):find(F==4);
alpha_range = find(F==8):find(F==12);

for i = 1:size(times, 2)   
    for j = 1:size(spectrograms, 2)
        d_powers(j) = sum(spectrograms(j).P(delta_range, times(i)));
        a_powers(j) = sum(spectrograms(j).P(alpha_range, times(i)));
    end
    
    subplot(size(times, 2), 2, i*2-1);
    topoplot(d_powers, '521282S_channel_locations.locs', 'maplimits', 'minmax'); % [0 1] scaling does not work
    title(sprintf('Delta power at {%1.f} s', (times(i))));
    
    subplot(size(times, 2), 2, i*2);
    topoplot(a_powers, '521282S_channel_locations.locs', 'maplimits', 'minmax'); % [0 1] scaling does not work
    title(sprintf('Alpha power at {%1.f} s', (times(i))));
end