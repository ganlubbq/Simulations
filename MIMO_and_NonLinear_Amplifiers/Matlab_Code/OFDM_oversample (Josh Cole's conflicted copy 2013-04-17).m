close all
clear all
Bandwith = 4.5e6;
deltaF = 15e3;
Nfft = 512;
N = 10;
T = 1/deltaF;
Ts = T/Nfft;
Nsubcarriers = 300;
TimeSample = (0:Nsubcarriers-1)*Ts;

h = [2 -1 -1 1 -1 -2 2 1 -3 1 3 -4 0 5 -4 -3 8 -2 -7 9 2 -12 7 9 -16 2 18 -17 -9 28 -12 -26 37 3 -55 45 46 -128 49 538];
InterperlationFilter =[-5 0 30 0 -103 0 278 0 -697 0 2545 4096 2545 0 -697 0 278 0 -103 0 30 0 -5];
OFDM_Filter = [ h fliplr(h)];

DCGain = sum(OFDM_Filter);
OFDM_Filter_Norm =OFDM_Filter/DCGain;

DCGain = sum(InterperlationFilter);
InterperlationFilter_Norm = InterperlationFilter/DCGain;

M = 16;
[ k, Es, Esnorm, Eb, Ebnorm, SymbArray ] = GetSymbolArrayData( M );
numBits = k*Nsubcarriers;

SubCarrierIndex = [-Nsubcarriers/2:-1 1: Nsubcarriers/2];
frame = [];
for numSymbols = 1:N
    Bits = rand(1,numBits) > 0.5;

    % Generate Symbol Index
    [ Idx, BlockSize ] = SymbolIndex( Bits, k );

    % Generate Symbols
    Symbols = SymbArray(Idx);

    % Generate OFDM Symbol
    OFDMSymbol = zeros(1,Nfft);
    OFDMSymbol(SubCarrierIndex+Nfft/2+1) = Symbols;
    powerOFDMSymbol = mean(abs(OFDMSymbol).^2);
    outputIDFT = ifft(fftshift(OFDMSymbol),Nfft)*sqrt(Nfft);
    poweroutputIDFT = mean(abs(outputIDFT).^2);

    % Generate Cyclic Prefic
    Ncp = 36;
    CyclicPrefix = outputIDFT((Nfft-Ncp)+1:Nfft);
    outputIDFT_CP = [CyclicPrefix outputIDFT];
    poweroutputIDFT_CP = mean(abs(outputIDFT_CP).^2);

    % Apply Filter
    OFDM_Filtered = conv(outputIDFT_CP,OFDM_Filter_Norm);
    frame = [frame OFDM_Filtered];
end

% Oversample
OversampleRate = 8;
NumberofOversamples = OversampleRate/2;

for ova = 1:NumberofOversamples
    N = length(frame);
    OVA = zeros(1,2*N);
    OVA(1:2:end) = frame;
    frametest = conv(OVA,InterperlationFilter_Norm);
end
x = frame;

backoff = input('Enter backoff in dB > ');
ts = 1/(OversampleRate*7.68e6);
n = length(x);

GaindB = -15:1:5;
% GaindB = 0;
gn = length(GaindB);

reference_case_rms   =1.5237;   % Speech 12.2Kbps AMR cubic reference value
                                        % equivalent to 20*log10(v_rms) for
                                      % the Speech case
BW = [1.25, 2.5, 5.0, 10.0, 15.0, 20.0]*1e6;
perecentage = (60.*BW).*(0.015./BW);
BWocc = perecentage.*BW;
OBW = perecentage.*BW./1e6;
OBW_ref = 3.84;
OBPD_All = 10*log10(OBW/OBW_ref);
K = 1.56;
OBPD = OBPD_All(3);
for m = 1:gn
    xnew = zeros(1,n);
    y = zeros(1,n);
    for k=1:n
        G = 10^(GaindB(m)/10);
        xnew(k) = G.*x(k);
        [ AM_AM(k), AM_PM(k), y(k) ] = AmplifierModel( xnew(k),-1*backoff );
        xnew(k) = 10^(-1*backoff/20).*xnew(k);
    end
    
    v_abs=abs(y);
    v_scale=sqrt(mean(v_abs.*v_abs));
    v_normalised=v_abs/v_scale;

    v_cubed=v_normalised.*v_normalised.*v_normalised;
    v_rms=sqrt(mean(v_cubed.*v_cubed));
    raw_cubic_metric = 20*log10(v_rms);
    
    WPD = ((raw_cubic_metric-reference_case_rms)/K);
    cubic_OFDM = WPD+ OBPD;
    
    EVM = sqrt(mean((abs(y-xnew).^2))/mean(abs(xnew).^2));
    Peak_to_meanx = 10*log10(max(abs(x).^2)/mean(abs(x).^2));
    Peak_to_meany = 10*log10(max(abs(y).^2)/mean(abs(y).^2));
    disp(['Gain dB = ',num2str(GaindB(m))])
    disp(['EVM = ',num2str(EVM)])
    disp(['Peak to Mean dB x = ',num2str(Peak_to_meanx)])
    disp(['Peak to Mean dB y = ',num2str(Peak_to_meany)])
    disp(['Raw Cubic Metric dB  = ',num2str(raw_cubic_metric)])
    disp(['Cubic Metric dB = ',num2str(cubic_OFDM)])

    
    EVMArray(m) = EVM;
        
    N = length(xnew);
    Ex = sum(abs(xnew).^2);
    Px = Ex/N;
    XRMS = sqrt(Px);
    xx(m) = XRMS;
    
    N = length(y);
    Ex = sum(abs(y).^2);
    Px = Ex/N;
    XRMS = sqrt(Px);
    yy(m) = XRMS;
    
    
    fftOFDM = 20*log10(abs(fft(y))*1/sqrt(length(y)));

    fs = 7.68*OversampleRate;
    F = 0:fs/(length(fftOFDM)-1):fs;

    [ fftF1, fftF2, MainChannel ] = getChannelData( [0 fs], F, fftOFDM );
    N = length(MainChannel);
    Ex = sum(abs(MainChannel).^2);
    Px = Ex/N;
    fftmainXRMS = sqrt(Px);

    [ fftF3, fftF4, adjChannel ] = getChannelData( [5], F, fftOFDM );

    N = length(adjChannel);
    Ex = sum(abs(adjChannel).^2);
    Px = Ex/N;
    fftadj1XRMS = sqrt(Px);
    
    [ LfftF3, LfftF4, adjChannel ] = getChannelData( [fs-5], F, fftOFDM );

    N = length(adjChannel);
    Ex = sum(abs(adjChannel).^2);
    Px = Ex/N;
    Lfftadj1XRMS = sqrt(Px);
    
    
    [ freq, psdy ] = WelchEstimate( y, Nfft, 0.5);
    welchy =10*log10(psdy);


    fs = 7.68*OversampleRate;
    F = 0:fs/(length(welchy)-1):fs;

    [ F1, F2, MainChannel ] = getChannelData( [0 fs], F, welchy.' );
    N = length(MainChannel);
    Ex = sum(abs(MainChannel).^2);
    Px = Ex/N;
    mainXRMS = sqrt(Px);

    [ F3, F4, adjChannel ] = getChannelData( [5], F, welchy.' );

    N = length(adjChannel);
    Ex = sum(abs(adjChannel).^2);
    Px = Ex/N;
    adj1XRMS = sqrt(Px);
    
    [ LF3, LF4, adjChannel ] = getChannelData( [fs-5], F, welchy.' );

    N = length(adjChannel);
    Ex = sum(abs(adjChannel).^2);
    Px = Ex/N;
    Ladj1XRMS = sqrt(Px);

    

    disp(['FFT main channel =', num2str(fftmainXRMS),' Adjacent Channel Upper =',num2str(fftadj1XRMS),'Adjacent Channel Lower =',num2str(Lfftadj1XRMS)])
    disp(['DSP main channel =', num2str(mainXRMS),' Adjacent Channel Upper =',num2str(adj1XRMS),'Adjacent Channel Lower =',num2str(Ladj1XRMS)])
    disp('-----------------------------------------------')
    
    figure
    subplot(2,1,1)
    plot(0:fs/(length(x)-1):fs,fftOFDM); grid; title('Output of Amplifier');
    ylabel('FFT in dB');
    hold on
    N = length(min(fftOFDM):max(fftOFDM)); 
    plot(repmat(fftF1(1),1,N),min(fftOFDM):max(fftOFDM),'g')
    plot(repmat(fftF2(1),1,N),min(fftOFDM):max(fftOFDM),'g')
    plot(repmat(fftF1(2),1,N),min(fftOFDM):max(fftOFDM),'g')
    plot(repmat(fftF2(2),1,N),min(fftOFDM):max(fftOFDM),'g')
    plot(repmat(fftF3,1,N),min(fftOFDM):max(fftOFDM),'r')
    plot(repmat(fftF4,1,N),min(fftOFDM):max(fftOFDM),'r')
    plot(repmat(LfftF3,1,N),min(fftOFDM):max(fftOFDM),'m')
    plot(repmat(LfftF4,1,N),min(fftOFDM):max(fftOFDM),'m')
    

    subplot(2,1,2)
    
    plot(F,welchy); grid; title('Output of Amplifier');
    ylabel('Welch in dB'); xlabel('Frequency in Hz');
    hold on
    N = length(min(welchy):max(welchy));
    plot(repmat(F1(1),1,N),min(welchy):max(welchy),'g')
    plot(repmat(F2(1),1,N),min(welchy):max(welchy),'g')
    plot(repmat(F1(2),1,N),min(welchy):max(welchy),'g')
    plot(repmat(F2(2),1,N),min(welchy):max(welchy),'g')
    plot(repmat(F3,1,N),min(welchy):max(welchy),'r')
    plot(repmat(F4,1,N),min(welchy):max(welchy),'r')
    plot(repmat(LF3,1,N),min(welchy):max(welchy),'m')
    plot(repmat(LF4,1,N),min(welchy):max(welchy),'m')
    
end

% [psdx,freq] = log_psd(x,n,ts);
% [psdy,freq] = log_psd(y,n,ts);
% [ freq, psdx ] = WelchEstimate( x, Nfft, ts );

figure
pin = 10*log10(xx); % input power in dB
pout = 10*log10(yy); % output power in dB
plot(pin,pin,'r'); 
hold on
plot(pin,pin-1,'g')
plot(pin,pout); grid;
xlabel('Input power - dB')
ylabel('Output power - dB')
legend('Input','1 dB Change', 'Output')

figure
plot(pin,10*log10(abs(yy./xx)))
grid on

figure
plot(pout,EVMArray)
grid on



