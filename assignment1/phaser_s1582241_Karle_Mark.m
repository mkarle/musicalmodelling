function [y] = phaser_s1582241_Karle_Mark( filename )
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% This is a function to read in a file called ‘filename.wav’ and perform
% a phaser effect using 4 concatenated 2nd order allpass filters.
%
% Example of usage:
% phaser...(‘guitar’)
% will read in the file guitar.wav and apply a phaser effect, play
% the sound and create an output .wav file called ‘guitar_phased.wav’
%
% This phaser works for stereo files, but the same phaser is applied to
% both ears
%~~~
acceptableName = false;
while(not(acceptableName))
    try
        [x, Fs] = audioread(filename);
        acceptableName = true;
    catch
        filename = input('Filename is not acceptable, please give a new one\n', 's');
    end
end
rate = 1;

R = [0.9, 0.981, 0.80, 0.9];
notchfreq = [300, 800, 1000, 4000];
theta = notchfreq / Fs * 2 * pi;
delta = 3 * theta;
% Apply time-varying allpass
y = x;
for channel = 1:size(x, 2)
    for i = 1:length(R)
        y(:,channel) = allpassTV_s1582241_Karle_Mark(y(:,channel),R(i),theta(i),delta(i),rate,Fs);
    end
end

%gain
g = 1;
y = y + g * x;
for i = 1:size(y,2)
    y(:,i) = y(:,i)./max(abs(y(:,i)));
end
%soundsc(y,Fs);
try
    audiowrite('output.wav',y,Fs);
catch
    disp('Not able to write file. Close open files and try again');
end

