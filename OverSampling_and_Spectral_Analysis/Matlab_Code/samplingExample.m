close all
clear all
% Natural frequency is 2*pi radians
% If sample rate is F_s HZ then 1 HZ is 2*pi/F_s
% If wave frequency is F_w then freequency is F_w* (2*pi/F_s)
% set n samples steps up to sum duration nsec*F_s where nsec is the
% duration in seconds
% So we get y = amp*sin(2*pi*n*F_w/F_s);
amp = 1;
F_s = 100;
F_w = 10;
nsec = 2;
dur= nsec*F_s;
t = (0:1/F_s:nsec);
n = 0:dur;
% ywave = amp*sin(2*pi*n*F_w/F_s);
ywave = amp*exp(1i*2*pi*n*F_w/F_s);
figure
subplot(2,1,1)
plot(t,ywave);
title('Sine Wave 1 Hz, Two Period''s');
xlabel('Time (Sec)');
ylabel('Amplitude');

F_snew = 1.5;
legend(['Nyquist Rate = ',num2str(F_snew)]);
SampleStart = 0;F_w/4;
dur= nsec*F_snew;
Ts = (SampleStart:1/F_snew:nsec);
n = F_snew*SampleStart:dur;
% Sampledy = amp*sin(2*pi*n*F_w/F_snew);
Sampledy = amp*exp(1i*2*pi*n*F_w/F_snew);
% Sampledy = abs(Sampledy);
hold on
stem(Ts,Sampledy,'r')
subplot(2,1,2)
plot(t,ywave);
title('Sine Wave 1 Hz, Two Period''s');
xlabel('Time (Sec)');
ylabel('Amplitude');
F_snew = 2;
SampleStart = 0;%F_w/4;
dur= nsec*F_snew;
Ts = (SampleStart:1/F_snew:nsec);
n = F_snew*SampleStart:dur;
Sampledy = amp*exp(1i*2*pi*n*F_w/F_snew);
hold on
stem(Ts,Sampledy,'r')
legend(['Nyquist Rate = ',num2str(F_snew)]);
% % To plot n cycles of a waveform
% ncyc = 1;
% n=0:floor(ncyc*F_s/F_w);
% % y = amp*sin(2*pi*n*F_w/F_s);
% N = n(end);
% figure
% plot(t(1:N),y(1:N));
% title('N Cycle Duration Sine Wave');
% xlabel('Time (Sec)');
% ylabel('Amplitude');
%%
t = 0:.02:3.14;
y = zeros(10,length(t));
x = zeros(size(t));
for k=1:2:19
    x = x + sin(k*t)/k;
    y((k+1)/2,:) = x;
end
figure
plot(y(1:2:9,:)')
title('The building of a square wave: Gibbs'' effect','FontSize',14)
%%
close all
clear all

amp = 1;
F_s = 100;
F1 = 1;
F2 = 2;
nsec = 2;

t = (0:1/F_s:nsec);
w1 = 2*pi*F1;
w2 = 2*pi*F2;
phase = 0;

y1 = amp*sin(t.*w1+phase);
y2 = amp*sin(t.*w2+phase);
ywave = (y1+y2)/2;

figure
plot(t,ywave,'r');
hold on
plot(t,y2)
title('N second Duration Sine Wave');
xlabel('Time (Sec)');
ylabel('Amplitude');
F_snew = 4;
SampleStart = 0;%F2/F_snew;
t = (SampleStart:1/F_snew:nsec);

S1 = amp*sin(t.*w1+phase);
S2 = amp*sin(t.*w2+phase);


ySampled = (S1+S2)/2;
mS = max(ySampled);
hold on
stem(t,ySampled,'r')