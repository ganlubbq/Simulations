close all
clear all
% PA Characteristics
AlphaA = 1;
BetaA = 1;
AlphaPhi = pi/48;
BetaPhi = 0.5;
p=3;

amplitudePointsdB = -15:1:3;
ampLin = 10.^(amplitudePointsdB / 20);   
NumberofSteps = length(amplitudePointsdB);
Nfft = 128;
f1 = 8;
f2 = 13;
F = 0:Nfft-1;
% for i = 1:NumberofSteps
%     MUx = ampLin(i).*exp(1i*2*pi*f1*[0:1/Nfft:0.999]);
%     phaseMUx = angle(MUx);
%     absMUx = abs(MUx);
%     AM_AM = (AlphaA.*absMUx)./(1+(BetaA.*absMUx).^2*p).^(1/(2*p));
%     AM_PM = (AlphaPhi.*absMUx.^2)./(1+BetaPhi.*absMUx.^2);  %change in Phase
%     
%     CW = AM_AM.*exp(1i*(phaseMUx+AM_PM));
%     
%     [ Normx, ux, Ex, Px, XRMS, simga2, DCGain, PowerGain ] = SignalInfo( MUx );
%     input(i) = XRMS;
%     [ Normx, ux, Ex, Px, XRMS, simga2, DCGain, PowerGain ] = SignalInfo( CW );
%     output(i) = XRMS;
%     [ Normx, ux, Ex, Px, XRMS, simga2, DCGain, PowerGain ] = SignalInfo( angle(CW) );
%     Phase(i) = XRMS;
%     [ Normx, ux, Ex, Px, XRMS, simga2, DCGain, PowerGain ] = SignalInfo( angle(MUx) );
%     PhaseMu(i) = XRMS;
% end
%     figure
%     plot(10*log10(input),10*log10(input))
%     hold on
%     plot(10*log10(input),10*log10(output),'r')
%     
% figure
% plot(real(MUx))
% hold on
% plot(real(CW),'r')
% 
% figure
% 
% MUxfft = 20*log10(abs((fft(MUx,Nfft)*1/sqrt(Nfft))));
% plot(F,MUxfft)
% hold on
% AM_AMfft = 20*log10(abs((fft(CW,Nfft)*1/sqrt(Nfft))));
% plot(F,AM_AMfft,'r');
% 
% figure
% [haxes,hline1,hline2] = plotyy(input,output,input,Phase,'plot','plot');
% 
% set(hline2,'LineStyle','--');
% axes(haxes(1));
% ylabel('Output Voltage (AM/AM)')
% axes(haxes(2));
% ylabel('Output Phase Change (AM/PM)')
% xlabel('Input Voltage')
% set(hline2,'LineStyle','--');
% title('Single Tone')
% 
% figure
% plot(input,input)
% hold on
% plot(input,output,'r')
% % [x,y] = gradient(output,input);


input = zeros(1,NumberofSteps);
output = zeros(1,NumberofSteps);
Phase = zeros(1,NumberofSteps);
PhaseMu = zeros(1,NumberofSteps);
OIP3 = zeros(1,NumberofSteps);
BackOffdB = 0;
BackOffLin = 10.^(BackOffdB / 10);   
for i = 1:NumberofSteps
    MUx = (ampLin(i).*exp(1i*2*pi*f1*[0:1/Nfft:0.999])+ampLin(i).*exp(1i*2*pi*f2*[0:1/Nfft:0.999]))/2;
    MUx =MUx./BackOffLin;
    phaseMUx = angle(MUx);
    absMUx = abs(MUx);
    AM_AM = (AlphaA.*absMUx)./(1+(BetaA.*absMUx).^2*p).^(1/(2*p));
    AM_PM = (AlphaPhi.*absMUx.^2)./(1+BetaPhi.*absMUx.^2);  %change in Phase
     
    CW = (AM_AM.*exp(1i*(phaseMUx+AM_PM)));
    
    [ Normx, ux, Ex, Px, XRMS, simga2, DCGain, PowerGain ] = SignalInfo( MUx );
    input(i) = XRMS;
    [ Normx, ux, Ex, Px, XRMS, simga2, DCGain, PowerGain ] = SignalInfo( CW );
    output(i) = XRMS;
    [ Normx, ux, Ex, Px, XRMS, simga2, DCGain, PowerGain ] = SignalInfo( angle(CW) );
    Phase(i) = XRMS;
    [ Normx, ux, Ex, Px, XRMS, simga2, DCGain, PowerGain ] = SignalInfo( angle(MUx) );
    PhaseMu(i) = XRMS;
  
%     figure
%     MUxfft = 20*log10(abs((fft(MUx,Nfft)*1/sqrt(Nfft))));
%     plot(F,MUxfft)
%  
%     hold on
    CWfft = 20*log10(abs((fft(CW ,Nfft)*1/sqrt(Nfft))));
    MUxfft = 20*log10(abs((fft(MUx ,Nfft)*1/sqrt(Nfft))));
    InputP0(i)=(MUxfft(f1+1)+MUxfft(f2+1))/2;
%     plot(F,CWfft,'.-r');
   
    f_IM3_1 = 2*f1-f2;
    f_IM3_2 = 2*f2-f1;
    P0(i) = (CWfft(f1+1)+CWfft(f2+1))/2;
    P03(i) = (CWfft(f_IM3_1+1)+CWfft(f_IM3_2+1))/2;
    
    IMD3 = P0(i)-P03(i);
    OIP3(i) = (IMD3/2)+P0(i);

    filter_output = CW;
    v_abs=abs(filter_output);
    v_scale=sqrt(mean(v_abs.*v_abs));
    v_normalised=v_abs/v_scale;

    v_cubed=v_normalised.*v_normalised.*v_normalised;
    v_rms=sqrt(mean(v_cubed.*v_cubed));
    raw_cubic_metric(i) = 20*log10(v_rms);
     
end 
temp1 = InputP0(1);
temp2 = P03(1);
for i = 1:40
    P0new(i) = temp1;
    P03new(i) = temp2;
    temp1 = temp1+1;
    temp2 = temp2+3;
end
figure
plot(P0new,P0new)
hold on
plot(InputP0,P0,'--')
plot(InputP0,P03,'--g')
plot(P0new,P03new,'g')

figure
plot(InputP0,InputP0)
hold on
plot(InputP0,P0,'r')
plot(InputP0,P03,'g')

% Grad
x = InputP0;
y = P0;
m = zeros(1,NumberofSteps-1);
for k=0:length(y)-2
    m(k+1) = ((y(k+2) - y(k+1)))/(x(k+2) - x(k+1));
end

IIP3 = OIP3 - 10*log10(output./input);

figure
plot(F,real(MUx))
hold on
plot(F,real(CW),'r')
legend('Input Wave','Output Wave')
 
figure
MUxfft = 20*log10(abs((fft(MUx,Nfft)*1/sqrt(Nfft))));
plot(F,MUxfft)

hold on
AM_AMfft = 20*log10(abs((fft(CW ,Nfft)*1/sqrt(Nfft))));
plot(F,CWfft,'.-r');

axis([0 128 min(CWfft) max(MUxfft)]) 
legend('Input','Output')

figure
[haxes,hline1,hline2] = plotyy(input,output,input,Phase,'plot','plot');

set(hline2,'LineStyle','--');
axes(haxes(1));
ylabel('Output Voltage (AM/AM)')
axes(haxes(2));
ylabel('Output Phase Change (AM/PM)')
xlabel('Input Voltage')
set(hline2,'LineStyle','--');
title('Two Tone')



