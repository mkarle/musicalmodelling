function [y] = phaserStereo_s1582241_Karle_Mark( filename )
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% This is a function to read in a file called ‘filename.wav’ and perform
% a phaser effect using 4 concatenated 2nd order allpass filters.
%
% Example of usage:
% phaser...(‘guitar’)
% will read in the file guitar.wav and apply a phaser effect, play
% the sound and create an output .wav file called ‘guitar_phased.wav’
%
% This phaser works for stereo files, but the different phaser effects are
% applied to both channels
%~~~
acceptableName = false;
while(not(acceptableName))
    try
        [x, Fs] = audioread(filename);
        acceptableName = true;
    catch
        filename = input('Filename is not acceptable. Five a new one\n', 's');
    end
    if not(size(x,2) == 2)
        filename = input('This is not a stereo file. Give a new file name.\n');
        acceptableName = false;
    end
end

N = length(x);

rate = 1.6;

R = [0.9, 0.8, 0.7, 0.99, 0.89, .98, .99,.99; 0.98, 0.85, 0.95, 0.78, 0.889, 0.995,.99,.99];

%phase on the highest amplitude frequency just for fun
%Also use its octaves and fifths
%divided everything by 10 because otherwise it sounded bad
XFLeft = fft(x(:,1));
XFRight = fft(x(:,2));
freqs = linspace(0,Fs -1, N);
maxLeft = freqs(find(abs(XFLeft)==max(abs(XFLeft))));
maxRight = freqs(find(abs(XFRight)==max(abs(XFRight))));
notchfreq = [maxLeft/10, maxLeft / 20, maxLeft * 2/10, maxLeft * 3/ 2/10, maxLeft * 2/3/10, maxLeft * 4/10 ...
    100,200; maxRight/10, maxRight /20, maxRight * 2/10, maxRight * 4/10, maxRight * 3/2/10, maxRight * 2/3/10 ...
    100,200];

theta = notchfreq / Fs * 2 * pi;
delta = 3 * theta;
% Apply time-varying allpass
y = x;
for channel = 1:size(x,2)
    for i = 1:length(R)
        y(:,channel) = allpassTV_s1582241_Karle_Mark(y(:,channel),R(channel, i),theta(channel,i),delta(channel,i),rate,Fs);
    end
end

%gain
g = .8;
y = y + g * x;
for i = 1:size(y,2)
    y(:,i) = y(:,i)./max(abs(y(:,i)));
end
%soundsc(y,Fs);
try
    audiowrite('outputStereo.wav',y,Fs);
catch
    disp('Not able to write file. Close open files and try again');
end
end

