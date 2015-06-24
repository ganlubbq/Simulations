close all 
clear all

f=1;                            % Input Signal Frequency
fs=2000;                        % Sampling Frequency
t=[0:f/fs:3-f/fs];              % Time Samples
x=sin(2*pi*t);                  % Generate Sine Wave  
theta = pi/2;                   % Define phase shift
xShift = sin(2*pi*t +theta);    % Shift Signal

% Plot Data
figure
subplot(3,1,1); 
hold on 
plot(t,x)
plot(t,xShift,'r')
hold off
PeriodLength = (length(x))/3;
Bt = [zeros(PeriodLength,1);ones(PeriodLength,1);zeros(PeriodLength,1)];    % Window
% Bt = ones(PeriodLength,1);
subplot(3,1,2);plot(t,Bt)
y =conv(x,Bt);
yShift =conv(xShift,Bt);
subplot(3,1,3);
hold on
t =(0:length(y)-1)/fs/2;              % Time Samples
plot(t,y);
t =(0:length(yShift)-1)/fs/2;              % Time Samples
plot(t,yShift,'r');
hold off

figure
subplot(3,1,1);  
f = -fs/2:fs/(length(Bt)-1):fs/2;
plot(f,20*log10(fftshift(abs(fft(Bt)))));
subplot(3,1,2);  
f = -fs/2:fs/(length(y)-1):fs/2;
plot(f,20*log10(fftshift(abs(fft(y)))));
subplot(3,1,3);  
f = -fs/2:fs/(length(yShift)-1):fs/2;
plot(f,20*log10(fftshift(abs(fft(yShift)))));
