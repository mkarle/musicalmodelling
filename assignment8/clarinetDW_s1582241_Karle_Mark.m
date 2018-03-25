%clarinetDW_s1582241_Karle_Mark
clear all, close all, clc;

Fs = 44100;


N = 3 * Fs;
ramp_up_time = round(Fs/2);
sustain_time = round(Fs);
ramp_down_time = round(Fs/2);
c = 343.2;%speed of sound in air in m/s

L = 0.675 ; %length of clarinet in meters
dLength = round(L / c * Fs); %length of delay lines in samples
d1 = zeros(dLength,1); % forward wave
d2 = zeros(dLength,1); % backward wave
ptr = 1; %pointer/index
delayedend = 0;
p_MP = zeros(N,1); % pressure at mouthpiece, as if there were a mic there
p_in = zeros(N,1);
p_in(1:ramp_up_time) = linspace(0,0.5,ramp_up_time);
p_in(ramp_up_time : ramp_up_time + sustain_time) = 0.5;
p_in(ramp_up_time + sustain_time + 1 : ramp_up_time + sustain_time + ramp_down_time) = linspace(0.5,0,ramp_down_time);

for n = 1 : N
    d1out = d1(ptr);
    p_MP(n) = d2(ptr);
    delta_p = p_MP(n) - p_in(n);
    r = 0.1 - 1.1 * delta_p;
    if r < -1
        r = -1;
    elseif r > 1
        r = 1;
    end
    d1(ptr) = p_in(n) + r * delta_p;
    p_MP(n) = p_MP(n) + d1(ptr);
    delayednext = d1out;
    d2(ptr) = -0.49 * (d1out + delayedend);
    delayedend = delayednext;
    ptr = ptr + 1;
    if ptr > dLength
        ptr  =1;
    end
end

subplot(2,1,1);
plot(p_MP);
title('P_MP');
xlabel('samples');
ylabel('Amplitude');

subplot(2,1,2);
p_MP_F = fft(p_MP);
plot(linspace(0,Fs/2,N/2),20 * log10(abs(p_MP_F(1:N/2))));
title('P_MP Frequency');
xlabel('Frequency (Hz)');
ylabel('Amplitude (dB)');

reverb = audioread('CleanAmpIR.wav');
p_MP = conv(reverb,p_MP);

p_MP = p_MP./norm(p_MP,Inf);
audiowrite('clarinetDW_s1582241_Karle_Mark.wav', p_MP,Fs);
soundsc(p_MP,Fs);