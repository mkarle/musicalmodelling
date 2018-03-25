notes = containers.Map({'C1', 'C#1', 'D1', 'D#1', 'E1', 'F1', 'F#1', 'G1', 'G#1', 'A1', 'A#1', 'B1',...
                        'C2', 'C#2', 'D2', 'D#2', 'E2', 'F2', 'F#2', 'G2', 'G#2', 'A2', 'A#2', 'B2',...
                        'C3', 'C#3', 'D3', 'D#3', 'E3', 'F3', 'F#3', 'G3', 'G#3', 'A3', 'A#3', 'B3',...
                        'C4', 'C#4', 'D4', 'D#4', 'E4', 'F4', 'F#4', 'G4', 'G#4', 'A4', 'A#4', 'B4'},...
                        {32.70 34.65 36.71 38.89 41.2 43.65 46.25 49 51.91 55 58.27 61.74...
                         65.41 69.3 73.42 77.78 82.41 87.31 92.5 98.0 103.83 110 116.54 123.47...
                         130.81 138.59 146.83 155.56 164.81 174.61 185.0 196.0 207.65 220 233.08 246.94...
                         261.63 277.18 293.66 311.13 329.63 349.29 369.99 392.0 415.3 440.0 466.16 493.88});
[u,Fs] = audioread('pluck.wav');
a = KarplusStrong_Extended_s1582241_Karle_Mark(notes('A2'), u, Fs);
c = KarplusStrong_Extended_s1582241_Karle_Mark(notes('C#4'), u, Fs);
e = KarplusStrong_Extended_s1582241_Karle_Mark(notes('E3'), u, Fs);
a3 = KarplusStrong_Extended_s1582241_Karle_Mark(notes('A3'), u, Fs);

for n = 1:3
soundsc(a,Fs);
pause(0.005);
soundsc(e,Fs);
pause(0.005);
soundsc(a3,Fs);
pause(0.005);
soundsc(c,Fs);
pause(0.5)
end