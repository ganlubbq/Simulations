close all
N = 10^6; 
x = randn(1, N); y = randn(1, N);   % Random Variables X and Y with Gaussian Distribution mean zero variance one
z = (x + 1i*y);             % Normalised Ralyiegh random Variable
% Convert To Polar Form
Z = sqrt(x.^2 + y.^2);              % Z = |z| Modulas of z
Theta = atan(y./x);                 % Angle of z

sigma2 = 1;
step = 0.01; 
Zrange = 0:step:7;                  % For Z>=0
Thetarange = -pi:step:pi;           % -pi<= Theta <=pi
Zh = hist(Z, Zrange); 
Thetah = hist(angle(z), Thetarange);

fr_approx = Zh/(step*N);
fr = (Zrange/sigma2).*exp(-(Zrange.^2)/(2*sigma2));

figure
subplot(2,1,1)
plot(Zrange, fr_approx,'r', Zrange, fr,'b');
legend('Simulated PDF', 'Analytical PDF')
title('PDF P(z)')
grid; 

% Theta

 
fr_approx = Thetah/(N*step);
fr = 1/(2*pi)*ones(size(Thetarange));


subplot(2,1,2)
plot(Thetarange, fr_approx,'r')
hold on
plot(Thetarange, fr,'b');
legend('Simulated PDF', 'Analytical PDF')
title('PDF P(theta)')
axis([-pi pi 0.14 0.18])
grid; 