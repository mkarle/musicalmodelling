function y = KarplusStrong_Extended_s1582241_Karle_Mark(f, u, Fs)
%I followed this pdf from Extended Karplus Strong to Distortion
%https://ccrma.stanford.edu/realsimple/faust_strings/faust_strings.pdf
distort = false;
N = round(Fs/f - .5);
rho = 0.95;

M = 160000;

%resample u
u = resample(u, N,round(length(u)*1/20));
x = zeros(N,1);

%% picking filter Hp
 pickCoeffs = [0.2 .9]; %up-pick and down-pick
 p = pickCoeffs(2);
 x(1) = (1-p) * u(1);
 for n = 2:N
     x(n) = (1-p) * u(n) + p * x(n-1);
 end
% %% pick position comb filter H_beta
 beta = 0.1;% beta is between 0 and 1, bridge and nut
 y = x;
 for n = floor(beta*N)+1 : N
     y(n) = x(n) - x(n-floor(beta*N));
 end
% 
 %% z^-N
 % two-zero string damping filter Hd
 % tuning the string H_nu
 nu = 0.5;
 B = [0.5, 0, 1, 0.01] ; %B brightness between 0 and 1
 g0 = (1 + B(4))/2;
 g1 = (1 - B(4))/4;
 x = y;
 y = zeros(N+M,1);
 y(1:N) = x;
 for n = N : length(y)
     
     %Hd
     y(n) = g1 * y(max(n-N,1)) + g0 * y(max(n-1-N,1)) + g1 * y(max(n-N-2,1));
     
     %Hnu
     y(n) = (1-nu) * y(max(n-N,1)) + nu * y(max(n-N-1,1));
     %z^-N
     y(n)= rho/2 *( y(max(n-N,1)) + y(max(n-(N+1),1)) );
 end
 
 %% Dynamic level lowpass filter H_L,omega
 omega = f * 2 * pi / Fs / 2;
 x = y;
 y(1) = omega * x(1);
 for n = 2:length(y)
     y(n) = omega * x(n) + omega * x(n-1) + (1-omega)*y(n-1);
 end

 %%  DC blocker
 x=y;
 dcR = 0.995;
 y(1) =  x(1);
 for n = 2:length(y)
     y(n) = x(n) - x(n-1) + dcR * y(n-1);
 end
 
 %% Distortion - cubic nonlinear
 %doesn't sound quite like it does on the website. not sure why.
%  if distort
%   x = 100*y;
%   c = 0.1;
%   for n = 1:length(y)
%       if (x(n)+c) <= -1
%           y(n) = -1/3.0;
%       elseif (x(n)+c) >= 1
%           y(n) = 1/3.0;
%       else
%           y(n) = (x(n)+c) - (x(n)+c)^3/3;
%       end
%   end
%  end
%% scale output and write to file
y = 2*(y - min(y))/(max(y) - min(y)) - 1;

%sound(y,Fs);

%audiowrite('ksOut_extended_s1582241_Karle_Mark.wav',y,Fs);
end