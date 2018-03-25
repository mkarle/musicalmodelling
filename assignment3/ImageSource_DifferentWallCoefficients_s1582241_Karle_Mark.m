clear all;
%roomsize in meters
%x,y,z coords of roomsize in meters
roomsize = [10 10 10];
%x,y,z coords of the receiver
receiver = [2 4 5];
%x,y,z coords of the source
source = [2 7 1];

%sample rate
Fs = 44100;

%number of virtual rooms along each dimension
N = 10;

%wall absorption coefficients for different material walls
%alpha(1) corresponds to walls on the x axis
%alpha(2) corresponds to walls on the y axis
%alpha(3) corresponds to the ceiling and floor
alpha = [0.9, 0.8, 0.3];
%max number of seconds possible plus a little bit
tf = sqrt( ((N+1) * roomsize(1))^2 + ((N+1) * roomsize(2))^2 + ((N+1) * roomsize(3))^2) / 343;

%energy impulse response
h = zeros(uint32(Fs * tf),1);

for d = -N : N
    A = (d + mod(d,2))*roomsize(1) + (-1)^mod(d,2) * source(1) - receiver(1);
    for e = -N : N
        B = (e + mod(e,2))*roomsize(2) + (-1)^mod(e,2) * source(2) - receiver(2);

        for f = -N : N
            C = (f + mod(f,2))*roomsize(3) + (-1)^mod(f,2) * source(3) - receiver(3);
            l_def = sqrt(A^2 + B^2 + C^2);
            t = l_def / 343;
            n = uint32(t * Fs);
            %the final absorption coeff will be the product of each alpha
            %each alpha is raised to the power of the number of walls on
            %its dimension that the sound reflects off of.
            %If all alphas are equal, this would be equivalent to 
            %alpha^(|d| + |e| + |f|)
            absorption = alpha(1)^abs(d)*alpha(2)^abs(e)*alpha(3)^abs(f);
            h(n) = h(n) + ( 1 / l_def) * absorption;
        end
    end
end
plot(h);
title('Energy Impulse Response');
xlabel('impulse (samples)');
ylabel('energy');

audiowrite(strcat('IR_DifferentWallCoefficients_',num2str(roomsize(1)),'mX',num2str(roomsize(2)),'mX',num2str(roomsize(3)),'m_s1582241_Karle_Mark.wav'), h,Fs);