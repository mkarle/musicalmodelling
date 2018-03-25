clear all;
%read in an audio sample and a reverb filter
[audio, Fs] = audioread('../assignment4/ksOut_s1582241_Karle_Mark.wav');
%[audio, Fs] = audioread('../audio/Dance_Mono.wav');
reverb = audioread('IR_10mX10mX10m_s1582241_Karle_Mark.wav');

M = length(audio);
N = length(reverb);
audio = [audio; zeros(N,1)];
reverb = [reverb; zeros(M,1)];
%fast convolution from the matlab tutorials
%matlab's conv function is still faster though
output = ifft(fft(audio).*fft(reverb));

output = 2*(output - min(output))/(max(output) - min(output)) - 1;
audiowrite('output.wav', output,Fs);