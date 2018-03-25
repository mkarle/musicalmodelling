clear all;
%split filename and extension so we can easily append _fuzzed or _tubed
filename = 'TestGuitarPhraseMono';
extension = '.wav';

try
    [x, Fs] = audioread(strcat(filename,extension));
catch
    'Could not read audio file.'
    return;
end

%G_fuzz distortion gain for the fuzz effect
G_fuzz = 10;
fuzz = fuzzyFunction_Karle_Mark(x, G_fuzz, Fs);

soundsc(fuzz,Fs);
%normalize fuzz
fuzz_norm = norm(fuzz,Inf);
if fuzz_norm ~= 0
    fuzz = fuzz / norm(fuzz,Inf);
end
try
    audiowrite(strcat(filename,'_fuzzed',extension), fuzz, Fs);
catch
    'Could not write fuzz distortion file'
    return;
end

%distortion gain for tube effect
G_tube = 10;
%work point, needs to be less than G_tube
Q = -3;
%harshness of distortion
D = 3;
%highpass parameter
r1 = 0.99;
%lowpass parameter
r2 = 0.8;
tube = vacuumtubeFunction_Karle_Mark(x, G_tube, Q, D, r1, r2);

%wait for other effect to finish playing
pause(length(fuzz)/Fs);
soundsc(tube,Fs);

%normalize tube
tube_norm = norm(tube,Inf);
if tube_norm ~= 0
    tube = tube / norm(tube,Inf);
end
try
    audiowrite(strcat(filename,'_tubed',extension), tube, Fs);
catch
    'Could not write tube distortion file'
    return;
end
