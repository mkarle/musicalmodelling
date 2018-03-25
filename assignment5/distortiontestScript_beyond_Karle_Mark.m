%this test uses CleanAmpIR.wav to get a more realistic output,
%the two distortion functions from the assignment,
%a distortion function given by Araya and Suyama from the PDF in Resources
%and a distortion function given by Doidic from the PDF in Resources
clear all;
%split filename and extension so we can easily append _fuzzed or _tubed
filename = 'clarinetDW_s1582241_Karle_Mark';
extension = '.wav';

%filename of an amp IR
amp_filename = 'CleanAmpIR.wav';

try
    [x, Fs] = audioread(strcat(filename,extension));
catch
    'Could not read audio file.'
    return;
end

try
    amp = audioread(amp_filename);
catch
    'Could not read amp IR file'
    return;
end

%G_fuzz distortion gain for the fuzz effect
G_fuzz = 10;
fuzz = fuzzyFunction_Karle_Mark(x, G_fuzz, Fs);
%convole the amp IR to make it sound more realistic
fuzz = conv(fuzz, amp);

soundsc(fuzz,Fs);
%normalize fuzz
fuzz_norm = norm(fuzz,Inf);
if fuzz_norm ~= 0
    fuzz = fuzz / norm(fuzz,Inf);
end
try
    audiowrite(strcat(filename,'_fuzzed_amped',extension), fuzz, Fs);
catch
    'Could not write fuzz distortion file'
    return;
end

%distortion gain for tube effect
G_tube = 10;
%work point, needs to be less than G_tube
Q = -3;
%harshness of distortion
D = 5;
%highpass parameter
r1 = 0.99;
%lowpass parameter
r2 = 0.8;
tube = vacuumtubeFunction_Karle_Mark(x, G_tube, Q, D, r1, r2);
tube = conv(tube, amp);

%wait for other effect to finish playing
pause(length(fuzz)/Fs);
soundsc(tube,Fs);

%normalize tube
tube_norm = norm(tube,Inf);
if tube_norm ~= 0
    tube = tube / norm(tube,Inf);
end
try
    audiowrite(strcat(filename,'_tubed_amped',extension), tube, Fs);
catch
    'Could not write tube distortion file'
    return;
end

araya = arayaAndSuyamaFunction_Karle_Mark(x);
araya = conv(araya,amp);
pause(length(tube)/Fs);
soundsc(araya,Fs);

araya_norm = norm(araya,Inf);
if araya_norm ~= 0
    araya = araya / araya_norm;
end
try
    audiowrite(strcat(filename,'_arayaandsuyama_amped',extension), tube, Fs);
catch
    'Could not write Araya and Suyama distortion file'
    return;
end

%slight distortion gain for doidic
G_doidic = 1.5;
doidic = doidic_Karle_Mark(x, G_doidic);
doidic = conv(doidic,amp);
pause(length(araya)/Fs);
soundsc(doidic,Fs);

doidic_norm = norm(doidic,Fs);
if doidic_norm ~= 0
    doidic = doidic / doidic_norm;
end

try
    audiowrite(strcat(filename,'_doidic_amped',extension), tube, Fs);
catch
    'Could not write Doidic distortion file'
    return;
end