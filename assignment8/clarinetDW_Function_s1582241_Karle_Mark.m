function [ p_MP ] = clarinetDW_Function_s1582241_Karle_Mark( L,N )
Fs = 44100;
ramp_up_time = round(N/30);
sustain_time = round(N/2);
ramp_down_time = round(N/30);
c = 343.2;%speed of sound in air in m/s

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

reverb = audioread('CleanAmpIR.wav');
p_MP = conv(reverb,p_MP);

p_MP = p_MP./norm(p_MP,Inf);

end

