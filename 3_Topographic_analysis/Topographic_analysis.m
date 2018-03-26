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

