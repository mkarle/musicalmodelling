clear all, close all, clc;
acceptableName = false;
while(not(acceptableName))
    try
        filename = input('Give an audio file: \n', 's');
        [x, Fs] = audioread(filename);
        acceptableName = true;
    catch
        disp('Filename is not acceptable.');
    end
    %Check number of channels in input
    cols = size(x,2);
    % I don't know if this would ever happen so I'm just making sure
    if cols > 2
        disp('Too many channels.');
        acceptableName = false;
    %Convert stereo to mono by averaging values
    elseif cols > 1
        x = (x(:,1) + x(:, 2))/2.0;
    end
end
R = 0.99; %value between 0 and 1
theta = pi / 4; %value between 0 and pi
y = allpass_s1582241_Karle_Mark(x, R, theta);

XF = fft(x);
YF = fft(y);
N = length(x);
freqBins = linspace(0, Fs-1, N); % 0 Hz to Fs-1 Hz
freqBins = freqBins.';

figure;
subplot(2, 2, 1);
%plot up to the nyquist
H = abs(YF(1:N/2))./abs(XF(1:N/2));
plot(freqBins(1:N/2), H);
title({'Magnitude Response H(z) = Y(z) / X(z)';strcat('R = ', num2str(R) , '  \theta = ' , num2str(theta)); strcat('Frequency based on \theta: ', num2str(theta * Fs / 2 / pi), ' Hz')});
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2, 2, 2);
plot(freqBins(1:N/2), angle(YF(1:N/2)) - angle(XF(1:N/2)));
title('Phase Response');
xlabel('Frequency (Hz)');
ylabel('Phase (rad)'); 

% plot of the whole system
notchY = x + y;
notchYF = fft(notchY);
subplot(2,2,3);
plot(freqBins(1:N/2), abs(notchYF(1:N/2))./abs(XF(1:N/2)));
title('Magnitude Response of whole system y + x');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2,2,4);
plot(freqBins(1:N/2), angle(notchYF(1:N/2)) - angle(XF(1:N/2)));
title('Phase Response of whole system y + x');
xlabel('Frequency (Hz)');
ylabel('Phase (rad)')


%%%%%%%
% up to 2kHz
figure;
subplot(2, 2, 1);
%plot up to 2kHz
plot(freqBins(1:2000 * N / Fs), abs(YF(1:2000 * N / Fs))./abs(XF(1:2000 * N / Fs)));
title({'Magnitude Response H(z) = Y(z) / X(z) up to 2kHz';strcat('R = ', num2str(R) , '  \theta = ' , num2str(theta)); strcat('Frequency based on \theta:', num2str(theta * Fs / 2 / pi), ' Hz')});
xlabel('Frequency (Hz)');
ylabel('Magnitude');
subplot(2, 2, 2);
plot(freqBins(1: 2000 * N / Fs), angle(YF(1:2000 * N / Fs)) - angle(XF(1:2000 * N / Fs)));
title('Phase Response up to 2kHz');
xlabel('Frequency (Hz)');
ylabel('Phase (rad)')

%%TODO note the frequency location based on theta 

% plot of the whole system
notchY = x + y;
notchYF = fft(notchY);
subplot(2,2,3);
plot(freqBins(1:2000 * N / Fs), abs(notchYF(1:2000 * N / Fs))./abs(XF(1:2000 * N / Fs)));
title('Magnitude Response of whole system up to 2kHz');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2,2,4);
plot(freqBins(1:2000 * N / Fs), angle(notchYF(1:2000 * N / Fs)) - angle(XF(1:2000 * N / Fs)));
title('Phase Response of whole system up to 2kHz');
xlabel('Frequency (Hz)');
ylabel('Phase (rad)')

%soundsc(notchY, Fs);