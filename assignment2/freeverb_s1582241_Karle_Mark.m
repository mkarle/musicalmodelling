%Implements Freeverb
%I used https://ccrma.stanford.edu/~jos/pasp/Freeverb.html and its subdirectories
%for the design of this matlab implementation 
%Better citation: 
%Smith, J.O. Physical Audio Signal Processing,
%http://ccrma.stanford.edu/~jos/pasp/, online book,
%2010 edition, accessed 10/2/2016.

%Freeverb simulates stereo by simply having a stereo offset, which is added
% to M, the order of the filters. They use 23 as default.
STEREO_OFFSET = 23;

[x, Fs] = audioread('DryGuitar.wav');

%convert stereo to mono
if size(x,2) ==2
    x = x(:,1) + x(:,2);
end

%these are for left channel
% coeffs chosen from https://ccrma.stanford.edu/~jos/pasp/Freeverb.html
a = 0.5;
M_allpass = [225 556 441 341];

yLeft = x;
yRight = x;

%%%%
% I chose not to implement the allpass filter given at
% https://ccrma.stanford.edu/~jos/pasp/Freeverb_Allpass_Approximation.html
% because it caused distortion in my implementation, so I stuck with my 
% own allpass filter.
%%%%
for n = 1:length(M_allpass)
    yLeft = allpassM_s1582241_Karle_Mark(yLeft, a, M_allpass(n));
    yRight = allpassM_s1582241_Karle_Mark(yRight, a, M_allpass(n) + STEREO_OFFSET);
end
allpassYLeft = yLeft; %save output so comb filters can work in parallel
allpassYRight = yRight;
M_comb = [1557 1617 1491 1422 1277 1356 1188 1116];
d = 0.2;
f = 0.84;
for n=1:length(M_comb)
    yLeft = yLeft + lowpasscomb_s1582241_Karle_Mark(allpassYLeft, d, f, M_comb(n));
    yRight = yRight + lowpasscomb_s1582241_Karle_Mark(allpassYRight, d, f, M_comb(n) + STEREO_OFFSET);
end

yLeft = yLeft./max(abs(yLeft));
yRight = yRight./max(abs(yRight));
if length(yLeft) < length(yRight)
    yLeft = [zeros(length(yRight) - length(yLeft),1) ; yLeft];
else
    yRight = [zeros(length(yLeft) - length(yRight),1) ; yRight];
end
min(yLeft)
max(yLeft)
y = [yLeft, yRight];
audiowrite('output.wav', y, Fs);
soundsc(y, Fs);