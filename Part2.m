close all;
clear sound;

% DSP Project - Part 2
% Step 1: Read an audio file
[audioSignal, fs] = audioread('Al2nas.wav');
audioSignal=audioSignal(:,1);
% disp(audioSignal);
%% 

% Step 2: Upsample the audio file by a factor of 2
upsampledSignal = resample(audioSignal, 2, 1);
%% 
% Frequency spectrum before and after upsampling

figure;

% Subplot 1: Frequency response before upsampling using freqz
freqz(audioSignal, 1, 1024, fs);
title('Freqz: Before Upsampling');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
figure;
% Subplot 2: Frequency response after upsampling using freqz
freqz(upsampledSignal, 1, 1024, fs * 2);
title('Freqz: After Upsampling');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
% 
% % Subplot 3: FFT spectrum before upsampling
figure;
subplot(2, 1, 1);
N = length(audioSignal);
f = (0:N-1)*(fs/N); % Frequency axis
magnitudeSpectrum = abs(fft(audioSignal));
plot(f(1:N/2), magnitudeSpectrum(1:N/2));
title('FFT: Before Upsampling');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Subplot 4: FFT spectrum after upsampling
subplot(2, 1,2 );
N = length(upsampledSignal);
f = (0:N-1)*(fs*2/N); % Frequency axis for upsampled signal
magnitudeSpectrum = abs(fft(upsampledSignal));
plot(f(1:N/2), magnitudeSpectrum(1:N/2));
title('FFT: After Upsampling');
xlabel('Frequency (Hz)');
ylabel('Magnitude');


%% 

% Step 4: Add a sinusoidal interference signal
t = (0:length(upsampledSignal)-1)' / (fs * 2); % Time vector for upsampled signal
interferenceFreq = 3000; % Frequency of the interference signal (adjustable)
interferenceSignal = 0.1 * sin(2 * pi * interferenceFreq * t); % Amplitude = 0.1

% Add interference
signalWithInterference = upsampledSignal + interferenceSignal;
% Plot the time-domain signals with distinct colors
figure;
plot(t, upsampledSignal, 'b'); % Blue for the audio signal
hold on; % Hold the current plot
plot(t, interferenceSignal, 'r'); % Red for the interference signal
hold off; % Release the plot hold

% Add legend
legend({'Audio Signal','' ,'Interference Signal'});
title('Time Domain Signal with Interference');


%%

% Step 5: Plot frequency spectrum after adding interference
figure;
N = length(signalWithInterference);
f = (0:N-1)*(fs*2/N); % Frequency axis (upsampled frequency)
magnitudeSpectrum = abs(fft(signalWithInterference)); % FFT and magnitude
plot(f(1:N/2), magnitudeSpectrum(1:N/2)); % Plot positive frequencies
title('Frequency Spectrum After Adding Interference');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
%%

% Step 6: Listen to the audio signal after adding interference
disp('Playing audio signal with interference...');
sound(signalWithInterference, fs * 2);
%%
% Step 7: Design a digital FIR filter using the filter design tool
disp('Designing FIR filter...');
%h=filter_design_tool;  % This function will ask for inputs and design the filter
h=filter_design_tool;
%__
% Normalize the filter coefficients to prevent amplification
h = h / sum(h);  % Normalize filter coefficients
%__
%% 
% Step 8:  Apply the filter to remove interference from the signal
filteredSignal = filter(h, 1, signalWithInterference);
filteredSignal = filter(h, 1, filteredSignal);
filteredSignal = filter(h, 1, filteredSignal);
%% 

% Step 9 : Plot the frequency spectrum of the filtered signal
figure;
N = length(filteredSignal);  % Number of samples
f = (0:N-1)*(fs*2/N);  % Frequency axis
magnitudeSpectrum = abs(fft(filteredSignal));  % FFT and magnitude
plot(f(1:N/2), magnitudeSpectrum(1:N/2));  % Plot positive frequencies
title('Frequency Spectrum After Filtering');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

figure;
freqz(h, 1, 1024, fs * 2);  % Plot frequency response of the designed filter
title('Frequency Response of the Designed Filter');
%% 

% Step 10: Listen to the filtered audio signal
disp('Playing filtered audio signal...');
sound(filteredSignal, fs * 2);
