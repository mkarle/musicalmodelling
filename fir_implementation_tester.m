[input, Fs] = audioread('audio/DryGuitar_mono_44100_481344.wav');
nTrials = 10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1) Filter impulse response
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = 44100;
Ts = 1.0 / Fs;
filtN = 6;
k = 1:filtN;
b = 0.5 * (1 - cos(2*pi*k/(filtN + 1)));
NFFT = 2^8;
h_padded = [b,zeros(1,NFFT - filtN)];
H = fft(h_padded);
H = H./(max(abs(H)));
fAxis = 0:Fs/length(h_padded):Fs - 1;
figure;
subplot(5,1,1);
stem(b);
title('Impulse Response of a moving average filter based on a Hann window');
xlabel('Time(samples)');
ylabel('Amplitude');

subplot(5,1,2);
title('Impulse Response of a moving average filter based on a Hann window(zero-padded)');
xlabel('Time (samples)');
ylabel('Amplitude');
plot(h_padded);

subplot(5,1,3);
title('Magnitude of Frequency Response H');
plot(fAxis, abs(H));
xlabel('Frequency(Hz)');
ylabel('|H(e^iomegaTs)|(normalized)');

subplot(5,1,4);
title('Magnitude of H in dB');
plot(fAxis, 20 * log10(abs(H)));
xlabel('Frequency(Hz)');
ylabel('|H(e^iomegaTs)|(dB)');

subplot(5,1,5);
title('Frequency response of the above filter (unwrapped phase)');
xlabel('Frequency(Hz)');
ylabel('Phase of H(e^iomegaTs)(radians)');
plot(fAxis, unwrap(angle(H)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2) Implement filtering by time domain convolution (manually done)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mean_timeRecord_convManual = zeros(60000/100,1);
mean_timeRecord_convMatlab = zeros(60000/100,1);
mean_timeRecord_filterMatlab = zeros(60000/100,1);
mean_timeRecord_freqDomainConv = zeros(60000/100,1);
for filtN=6:100:60000
timeRecord_convManual = zeros(nTrials, 1);

for nLoop = 1:nTrials
    tic;
    
    %x = [zeros(filtN-1,1);input];
    %for n=filtN:filtN-1+length(input)
    %    y_convManual = b*x(n:-1:n-filtN+1);
    %end
    timeRecord_convManual(nLoop) = toc;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3) Implement filtering by time domain convolution (Matlab ’conv’)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

timeRecord_convMatlab = zeros(nTrials, 1);

for nLoop = 1:nTrials
    tic;
    y_convMatlab = conv(b, input);
    timeRecord_convMatlab(nLoop) = toc;
end
mean_timeRecord_convMatlab((filtN - 6) / 100 +1) = mean(timeRecord_convMatlab);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4) FIR filter with matlab filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timeRecord_filterMatlab = zeros(nTrials,1);
filterInput = [input; zeros(filtN-1,1)];
for nLoop = 1:nTrials
    tic;
    
    y_filterMatlab = filter(b, 1, filterInput);
    timeRecord_filterMatlab(nLoop) = toc;
end
mean_timeRecord_filterMatlab((filtN - 6)/100 +1) = mean(timeRecord_filterMatlab);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5) FIR filter with fast FFT-based convolution in freq domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

timeRecord_freqDomainConv = zeros(nTrials,1);
testB = [b.'; zeros(length(input) -1,1)];
testInput = [input; zeros(length(b) -1,1)];
for nLoop = 1:nTrials
    tic;
    y_convFreqDomain = ifft(fft(testB).*fft(testInput));
    timeRecord_freqDomainConv(nLoop) = toc;
end
mean_timeRecord_freqDomainConv((filtN - 6) /100 +1) = mean(timeRecord_freqDomainConv);
end

figure;
xaxis = 6:100:60000;
plot(xaxis, mean_timeRecord_convManual, xaxis, mean_timeRecord_convMatlab, xaxis, mean_timeRecord_filterMatlab, xaxis, mean_timeRecord_freqDomainConv);
legend('conv manual', 'conv matlab', 'filter matlab', 'freq domain conv');