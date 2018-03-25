%creates a  musical phrase for the clarinet DW
clear all, close all, clc;

Fs = 44100;
B2 = 0.675; %length
notes = containers.Map({'C1', 'C#1', 'D1', 'D#1', 'E1', 'F1', 'F#1', 'G1', 'G#1', 'A1', 'A#1', 'B1',...
    'C2', 'C#2', 'D2', 'D#2', 'E2', 'F2', 'F#2', 'G2', 'G#2', 'A2', 'A#2', 'B2',...
    'C3', 'C#3', 'D3', 'D#3', 'E3', 'F3', 'F#3', 'G3', 'G#3', 'A3', 'A#3', 'B3',...
    'C4', 'C#4', 'D4', 'D#4', 'E4', 'F4', 'F#4', 'G4', 'G#4', 'A4', 'A#4', 'B4'},...
    {B2*2*(13/12), B2*2*(9/8), B2*2*(6/5), B2*2*(5/4), B2*2*(4/3), B2*2*(45/32), B2*2*(3/2),B2*2*(8/5),B2*2*(5/3),B2*2*(9/5),B2*2*(15/8), B2*(1/2)...
    B2*(13/12), B2*(9/8), B2*(6/5), B2*(5/4), B2*(4/3), B2*(45/32), B2*(3/2),B2*(8/5),B2*(5/3),B2*(9/5),B2*(15/8), B2...
    B2/(13/12), B2/(9/8), B2/(6/5), B2/(5/4), B2/(4/3), B2/(45/32), B2/(3/2),B2/(8/5),B2/(5/3),B2/(9/5),B2/(15/8), B2/2 ...
    B2/2/(13/12), B2/2/(9/8), B2/2/(6/5), B2/2/(5/4), B2/2/(4/3), B2/2/(45/32), B2/2/(3/2),B2/2/(8/5),B2/2/(5/3),B2/2/(9/5),B2/2/(15/8), B2/4});
N = 2*Fs;
a3 = clarinetDW_Function_s1582241_Karle_Mark(notes('A3'),N);
d3 = clarinetDW_Function_s1582241_Karle_Mark(notes('D3'),N);
f3 = clarinetDW_Function_s1582241_Karle_Mark(notes('F3'),Fs);
c4 = clarinetDW_Function_s1582241_Karle_Mark(notes('C4'),Fs);
b3 = clarinetDW_Function_s1582241_Karle_Mark(notes('B3'),N);
g3 = clarinetDW_Function_s1582241_Karle_Mark(notes('G3'),Fs);
e3 = clarinetDW_Function_s1582241_Karle_Mark(notes('E3'),Fs);
c3 = clarinetDW_Function_s1582241_Karle_Mark(notes('C3'),Fs);

soundsc(a3,Fs);
pause(1);
soundsc(d3,Fs);
pause(1.5);
soundsc(f3,Fs);
pause(1);
soundsc(a3,Fs);
pause(1);
soundsc(d3,Fs);
pause(2);
soundsc(f3,Fs);
pause(1);
soundsc(a3,Fs);
pause(0.5);
soundsc(c4,Fs);
pause(0.5);
soundsc(b3,Fs);
pause(1);
soundsc(g3,Fs);
pause(1);
soundsc(f3,Fs);
pause(0.5);
soundsc(g3,Fs);
pause(0.5);
soundsc(a3,Fs);
pause(1);
soundsc(d3,Fs);
pause(1);
soundsc(c3,Fs);
pause(0.5);
soundsc(e3,Fs);
pause(0.5);
soundsc(d3,Fs);
pause(2);
soundsc(d3,Fs);
soundsc(a3,Fs);
soundsc(f3,Fs);