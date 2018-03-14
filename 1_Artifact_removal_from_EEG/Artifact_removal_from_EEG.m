%% 1

EEG_data = load('521282S_data.mat');

figure('Name', 'EEG data');
plot(EEG_data.t, EEG_data.signal + EEG_data.spread);
legend(EEG_data.channelnames);
xlabel('t (s)');
title('EEG data');

%% 2

LP = filter(lowpass, EEG_data.signal);
[b, a] = notch();
notched = filtfilt(b, a, LP);
HP = filter(highpass, notched);

figure('Name', 'Low pass filter');
plot(EEG_data.t, LP + EEG_data.spread);
legend(EEG_data.channelnames);
xlabel('t (s)');
title('Low pass filter');

figure('Name', 'Notch filter');
plot(EEG_data.t, notched + EEG_data.spread);
legend(EEG_data.channelnames);
xlabel('t (s)');
title('Notch filter');

figure('Name', 'High pass filter');
plot(EEG_data.t, HP + EEG_data.spread);
legend(EEG_data.channelnames);
xlabel('t (s)');
title('High pass filter');

%% 3

adaptive_filter = dsp.LMSFilter('Length', 11, 'Method', 'LMS', 'StepSize', 0.6, 'WeightsOutputPort', 'false');
signal = HP;

% Adaptive filtering for EOG1

for i = 1:length(EEG_data.channelnames)
    for j = 1:10
         [out1, out2] = step(adaptive_filter, signal(:, 14), signal(:, i));
    end
    signal(:, i) = out2;
end

figure('Name', 'EOG1 adaptive filter');
plot(EEG_data.t, signal + EEG_data.spread);
legend(EEG_data.channelnames);
xlabel('t (s)');
title('EOG1 adaptive filter');

% Adaptive filtering for EOG2

for i = 1:length(EEG_data.channelnames)
    for j = 1:10
         [out1, out2] = step(adaptive_filter, signal(:, 15), signal(:, i));
    end
    signal(:, i) = out2;
end

figure('Name', 'EOG1 and EOG2 adaptive filter');
plot(EEG_data.t, signal + EEG_data.spread);
legend(EEG_data.channelnames);
xlabel('t (s)');
title('EOG1 and EOG2 adaptive filter');

%% 4

[ics, A, W] = fastica(HP');
scale = 1/100;

figure;
plot(EEG_data.t, ics' * scale + EEG_data.spread);
xlabel('t (s)');
title('Independent components');

ics(4:6, :) = 0;
signals = A * ics;

figure('Name', 'Artifacts removed');
plot(EEG_data.t, signals' + EEG_data.spread);
legend(EEG_data.channelnames);
xlabel('t (s)');
title('Artifacts removed');
