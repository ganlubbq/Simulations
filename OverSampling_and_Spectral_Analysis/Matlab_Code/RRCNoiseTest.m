clear all 
close all
rate = 8;

h = ones(1,rate);

lenH = length(h);
val = round(lenH/2);
ovTxbit = zeros(800,1);

txbit = (rand(100,1)<0.5)*2-1;
ovTxbit(1:rate:end) = txbit;
N = length(txbit);
t = (0 : N-1);
tOversampled = (0 :1/rate:N-1/rate);
f = (0 : N-1) / N;
f1= f(1);
f2 = f(2);
temp = (f2-f1)/rate;
No = length(ovTxbit);
freq= (0 : No-1) / No;
fil = conv(h,ovTxbit);
[eyed1] = eyeDiagram( val , fil );
% tf = (0 :length(fil)-1)/rate;
tf =(0:800/807:800-800/807)/rate;
figure
subplot(3,1,1); plot(t,txbit)
axis([0 10 -1 1])
title('Time Domain Transmitted Bits');
subplot(3,1,2); plot(tOversampled,ovTxbit)
axis([0 10 -1 1])
title(['Time Domain Over Sampled rate = ', num2str(rate)]);
subplot(3,1,3); plot(tf,fil)
axis([0 10 -1 1])
title('Rect-Filter Implementation');
pause

% figure
% subplot(2,1,1); plot(f,20*log10(abs(fft(txbit))))
% title('Frequency Domain Transmitted Bits');
% subplot(2,1,2); plot(freq,20*log10(abs(fft(ovTxbit))))
% title(['Frequency Domain Over Sampled rate = ', num2str(rate)]);
% pause

% Rect Filter
% -----------

figure
subplot(3,1,1); plot(fil)
title('Rect-Filter Implementation');
subplot(3,1,2); plot(20*log10(abs(fft(fil))))
title('Rect-Filter Implementation');
subplot(3,1,3); plot(eyed1,'b')
title('Eye Diagram Rect-Filter Implementation');
pause

[ RxSymbol, Noise ,No, NoiseVar ] = TransmitSymbol( reshape(fil,1,[]), 1, 1, 100 );
[eyed2] = eyeDiagram( val , RxSymbol );

figure
subplot(2,1,1); plot(1:length(RxSymbol),real(RxSymbol))
title(['Time Domain Over Sampled rate = ', num2str(rate)]);
subplot(2,1,2); plot(eyed2,'b')
title('Eye Diagram Rect-Filter Implementation');
%%
close all
clear all
rate = 8;
h = ones(1,rate);
val = 65;
Filter1 = ...
    [    
    0.0008
    0.0005
   -0.0000
   -0.0006
   -0.0012
   -0.0015
   -0.0011
    0.0000
    0.0017
    0.0033
    0.0039
    0.0029
   -0.0000
   -0.0040
   -0.0076
   -0.0088
   -0.0063
    0.0000
    0.0084
    0.0157
    0.0181
    0.0129
   -0.0000
   -0.0173
   -0.0327
   -0.0387
   -0.0288
    0.0000
    0.0451
    0.0989
    0.1500
    0.1867
    0.2000
    0.1867
    0.1500
    0.0989
    0.0451
    0.0000
   -0.0288
   -0.0387
   -0.0327
   -0.0173
   -0.0000
    0.0129
    0.0181
    0.0157
    0.0084
    0.0000
   -0.0063
   -0.0088
   -0.0076
   -0.0040
   -0.0000
    0.0029
    0.0039
    0.0033
    0.0017
    0.0000
   -0.0011
   -0.0015
   -0.0012
   -0.0006
   -0.0000
    0.0005
    0.0008
];
numBits = 100;
ovTxbit = zeros(800,1);
txbit = (rand(100,1)<0.5)*2-1;
ovTxbit(1:rate:end) = txbit;
[ w ] = Hanning( rate*numBits );
filR = conv(h,ovTxbit);
filZeroPad = conv(Filter1,ovTxbit);
filRect = conv(Filter1,filR);
% filRect = conv(Filter1,filR);
N = length(filZeroPad);
tup = 0:numBits/N:numBits -numBits/N;

figure
subplot(2,1,1); plot(tup,filZeroPad)
title('Time Domain Analogue filter zero padding');
subplot(2,1,2); plot(rate*tup,20*log10(abs(fft(filZeroPad))))
title('Frequency Domain Analogue filter zero padding');
pause

N = length(filRect);
tup = 0:numBits/N:numBits -numBits/N;

figure
subplot(2,1,1); plot(tup,filRect)
title('Time Domain Analogue filter Rect-filtered');
subplot(2,1,2); plot(rate*tup,20*log10(abs(fft(filRect))))
title('Frequency Domain Analogue filter Rect-filtered');
pause

tzeropad = (0:(rate*numBits)/(length(filZeroPad)):(rate*numBits)-(rate*numBits)/(length(filZeroPad)))/rate;
trect = (0:(rate*numBits)/(length(filRect)):(rate*numBits)-(rate*numBits)/(length(filRect)))/rate;

figure
subplot(2,1,1); plot(tzeropad,filZeroPad)
axis([0 10 -1 1])
title('Time Domain Analogue filter zero padding');
subplot(2,1,2); plot(trect,filRect)
axis([0 10 -1 1])
title('Frequency Domain Analogue filter Rect-filtered');
pause

[ eyeD1 ] = eyeDiagram( val , filZeroPad );
[ eyeD2 ] = eyeDiagram( val , filRect );

figure
subplot(2,1,1); plot(eyeD1,'b')
title('Eye Diagram Analogue filter zero padding');
subplot(2,1,2); plot(eyeD2,'b')
title('Eye Diagram Analogue filter Rect-filtered');
pause

% [ RxSymbol, Noise ,No, NoiseVar ] = TransmitSymbol( reshape(filZeroPad,1,[]), 1, 1, inf );
% [ eyeD3 ] = eyeDiagram( 2*val , RxSymbol );
% 
% [ RxSymbol, Noise ,No, NoiseVar ] = TransmitSymbol( reshape(filRect,1,[]), 1, 1, inf );
% 
% [ eyeD4 ] = eyeDiagram( val , RxSymbol );
% 
% figure
% subplot(2,1,1); plot(eyeD3,'b')
% title('Eye Diagram Analogue filter zero padding');
% subplot(2,1,2); plot(eyeD4,'b')
% title('Eye Diagram Analogue filter zero padding');
% pause

%%
close all
clear all
rate = 8;
val = 65;
Filter2 = ...
    [   
   -0.0000
   -0.0003
   -0.0007
   -0.0010
   -0.0013
   -0.0015
   -0.0014
   -0.0009
    0.0000
    0.0013
    0.0029
    0.0045
    0.0058
    0.0063
    0.0056
    0.0036
   -0.0000
   -0.0048
   -0.0101
   -0.0153
   -0.0190
   -0.0203
   -0.0180
   -0.0113
    0.0000
    0.0156
    0.0347
    0.0558
    0.0770
    0.0963
    0.1118
    0.1218
    0.1253
    0.1218
    0.1118
    0.0963
    0.0770
    0.0558
    0.0347
    0.0156
    0.0000
   -0.0113
   -0.0180
   -0.0203
   -0.0190
   -0.0153
   -0.0101
   -0.0048
   -0.0000
    0.0036
    0.0056
    0.0063
    0.0058
    0.0045
    0.0029
    0.0013
    0.0000
   -0.0009
   -0.0014
   -0.0015
   -0.0013
   -0.0010
   -0.0007
   -0.0003
   -0.0000
];
FAnalogue = ...
    [    
    0.0008
    0.0005
   -0.0000
   -0.0006
   -0.0012
   -0.0015
   -0.0011
    0.0000
    0.0017
    0.0033
    0.0039
    0.0029
   -0.0000
   -0.0040
   -0.0076
   -0.0088
   -0.0063
    0.0000
    0.0084
    0.0157
    0.0181
    0.0129
   -0.0000
   -0.0173
   -0.0327
   -0.0387
   -0.0288
    0.0000
    0.0451
    0.0989
    0.1500
    0.1867
    0.2000
    0.1867
    0.1500
    0.0989
    0.0451
    0.0000
   -0.0288
   -0.0387
   -0.0327
   -0.0173
   -0.0000
    0.0129
    0.0181
    0.0157
    0.0084
    0.0000
   -0.0063
   -0.0088
   -0.0076
   -0.0040
   -0.0000
    0.0029
    0.0039
    0.0033
    0.0017
    0.0000
   -0.0011
   -0.0015
   -0.0012
   -0.0006
   -0.0000
    0.0005
    0.0008
];
numBits = 100;
ovTxbit = zeros(numBits*rate,1);
txbit = (rand(numBits,1)<0.5)*2-1;
ovTxbit(1:rate:end) = txbit;

filImpRes = conv(Filter2,ovTxbit);
N = length(filImpRes);
tup = 0:numBits/N:numBits -numBits/N;

figure
subplot(2,1,1); plot(tup,filImpRes)
title('Time Domain Impulse Response');
subplot(2,1,2); plot(rate*tup,20*log10(abs(fft(filImpRes))))
title('Frequency Domain Impulse Response');
pause


filwithAnalogue = conv(FAnalogue,filImpRes);

timpRes = (0:(rate*numBits)/(length(filImpRes)):(rate*numBits)-(rate*numBits)/(length(filImpRes)))/rate;
tAnalogue = (0:(rate*numBits)/(length(filwithAnalogue)):(rate*numBits)-(rate*numBits)/(length(filwithAnalogue)))/rate;

figure
subplot(2,1,1); plot(timpRes,filImpRes)
axis([0 20 -1 1])
title('Time Domain  filter');
subplot(2,1,2); plot(tAnalogue,filwithAnalogue)
axis([0 20 -1 1])
title('Frequency Domain filter+ Anologue Filter');
pause

[eyeD1] = eyeDiagram( val , filImpRes );
[eyeD2] = eyeDiagram( val , filwithAnalogue );

figure
subplot(2,1,1); plot(eyeD1,'b')
title('Eye Diagram Specified Filter');
subplot(2,1,2); plot(eyeD2,'b')
title('Eye Diagram Analogue filter + Specified Filter');
pause

% [ RxSymbol, Noise ,No, NoiseVar ] = TransmitSymbol( reshape(fil,1,[]), 1, 1, inf );
%%
clear all
close all
rate = 8;
filterNomalisation = 1/sqrt(rate);
[ h ] = RootRaiseCosine( 0.22, rate );
numBits =2^10;
lenH = length(h);
ovTxbit = zeros(rate*numBits,1);
txbit = (rand(numBits,1)<0.5)*2-1;
ovTxbit(1:rate:end) = txbit;

rrcFiltered = filterNomalisation*conv(h,ovTxbit);
N = length(rrcFiltered);
t = (0:numBits-1);
tup = 0:numBits/N:numBits -numBits/N;

figure
subplot(3,1,1); plot(tup,rrcFiltered)
title('Time Domain RRC Filtered Signal');
subplot(3,1,2); plot(rate*tup,10*log10(abs(fft(rrcFiltered))))
title('Frequency Domain Filtered Signal');
val = round(lenH/2);
[eyeD1] = eyeDiagram( val , rrcFiltered );
subplot(3,1,3); plot(eyeD1,'b')
title('Eye Diagram RRC Filtered Signal');
pause

[ RxSymbol, Noise ,No, NoiseVar ] = TransmitSymbol( reshape(rrcFiltered,1,[]), 1, 1, inf );
rrcFiltered2 = filterNomalisation*conv(RxSymbol,h);
N = length(rrcFiltered2);
tup = 0:numBits/N:numBits -numBits/N;

figure
subplot(3,1,1); plot(tup,real(rrcFiltered2))
title('Time Domain RRC Filtered Signal');
subplot(3,1,2); plot(rate*tup,10*log10(abs(fft(rrcFiltered2))))
title('Frequency Domain Filtered Signal');
[eyeD2] = eyeDiagram( 2*val , rrcFiltered2 );
subplot(3,1,3); plot(eyeD2,'b')
title('Eye Diagram RRC Filtered Signal');
%%
clear all 
close all
Fs = 8;


M = 4;

[ k, Es, Esnorm, Eb, Ebnorm, SymbolArray ] = GetSymbolArrayData( M );
numBits = k*(2^8);
% TxSymbol= (rand(numBits,1)<0.5)*2-1;
Txbits = double(rand(1,numBits) > 0.5);
[ TxSymbolIdx, TrCHFrameSize ] = SymbolIndex( Txbits, k );
[ TxSymbol ] = SymbolArray(TxSymbolIdx);
numSymbols = length(TxSymbol);
n = numSymbols;
t = 0:n-1;
freq_res = Fs/n;
f = freq_res*(0:n-1);
Bandwidth = f(end);

txUpSample = zeros(Fs*numSymbols,1);
txUpSample(1:Fs:end) = TxSymbol;

N = length(txUpSample);
T = (0:N-1)/Fs;
freq_resUp = Fs/N;
F = freq_resUp*(0:N-1);
BandwidthUpSample = F(end);

figure
subplot(2,1,1); plot(t,real(TxSymbol))
axis([0 20 -1 1])
title('Time Domain Transmitted Bits');

subplot(2,1,2); plot(T,real(txUpSample))
axis([0 20 -1 1])
title(['Time Domain Over Sampled Fs = ',num2str(Fs)]);
pause

figure
subplot(2,1,1); plot(f,10*log10(abs(fft(TxSymbol))))
% axis([0 20 -1 1])
title('Frequency Domain Transmitted Bits');

subplot(2,1,2); plot(F,10*log10(abs(fft(txUpSample))))
% axis([0 20 -1 1])
title(['Frequency Domain Over Sampled Fs = ',num2str(Fs)]);
pause

FilterRec = ones(1,Fs);
FilterRecOutput = conv(FilterRec,txUpSample);
t= T;
f= F;

N = length(FilterRecOutput);
T = (0:N-1)/Fs;
freq_resUp = Fs/N;
F = freq_resUp*(0:N-1);

figure
subplot(2,1,1); plot(t,real(txUpSample))
axis([0 20 -1 1])
title(['Time Domain Over Sampled Fs = ',num2str(Fs)]);

subplot(2,1,2); plot(T,real(FilterRecOutput))
axis([0 20 -1 1])
title('Time Domain Rectangular Filter');
pause

figure
subplot(2,1,1); plot(f,10*log10(abs(fft(txUpSample))))
% axis([0 20 -1 1])
title('Frequency Domain Transmitted Bits');

subplot(2,1,2); plot(F,10*log10(abs(fft(FilterRecOutput))))
% axis([0 20 -1 1])
title('Frequency Domain Rectangular Filter');
pause

% PSD
% ---
NfftArray = [2^7 2^8 2^9 2^10];

for j = 1:2
    if j ==1
        x = txUpSample;
        xTitle = 'Over Sampled Singal   ';
    elseif j ==2
        x = FilterRecOutput;
        xTitle = 'Rectangular Filtered Singal   ';
    end
    for i = 1:length(NfftArray)
        Nfft = NfftArray(i);
        [ win ] = Hanning( Nfft );
        [Pxx,F] = pwelch(x,win,[],Nfft,Fs,'twosided');

        figure
        subplot(2,1,1); plot(win)
        axis([0 length(win) 0 1])
        title([xTitle,'Hanning Window']);
        subplot(2,1,2); plot(F,Pxx)
        title([xTitle,'PSD Estimate Fs = ', num2str(Fs),'  Overlap percentage = 50%','  NFFT = ',num2str(Nfft)]);
        pause
    end
end

Filter = ...
    [   
   -0.0000
   -0.0003
   -0.0007
   -0.0010
   -0.0013
   -0.0015
   -0.0014
   -0.0009
    0.0000
    0.0013
    0.0029
    0.0045
    0.0058
    0.0063
    0.0056
    0.0036
   -0.0000
   -0.0048
   -0.0101
   -0.0153
   -0.0190
   -0.0203
   -0.0180
   -0.0113
    0.0000
    0.0156
    0.0347
    0.0558
    0.0770
    0.0963
    0.1118
    0.1218
    0.1253
    0.1218
    0.1118
    0.0963
    0.0770
    0.0558
    0.0347
    0.0156
    0.0000
   -0.0113
   -0.0180
   -0.0203
   -0.0190
   -0.0153
   -0.0101
   -0.0048
   -0.0000
    0.0036
    0.0056
    0.0063
    0.0058
    0.0045
    0.0029
    0.0013
    0.0000
   -0.0009
   -0.0014
   -0.0015
   -0.0013
   -0.0010
   -0.0007
   -0.0003
   -0.0000
];
FAnalogue = ...
    [    
    0.0008
    0.0005
   -0.0000
   -0.0006
   -0.0012
   -0.0015
   -0.0011
    0.0000
    0.0017
    0.0033
    0.0039
    0.0029
   -0.0000
   -0.0040
   -0.0076
   -0.0088
   -0.0063
    0.0000
    0.0084
    0.0157
    0.0181
    0.0129
   -0.0000
   -0.0173
   -0.0327
   -0.0387
   -0.0288
    0.0000
    0.0451
    0.0989
    0.1500
    0.1867
    0.2000
    0.1867
    0.1500
    0.0989
    0.0451
    0.0000
   -0.0288
   -0.0387
   -0.0327
   -0.0173
   -0.0000
    0.0129
    0.0181
    0.0157
    0.0084
    0.0000
   -0.0063
   -0.0088
   -0.0076
   -0.0040
   -0.0000
    0.0029
    0.0039
    0.0033
    0.0017
    0.0000
   -0.0011
   -0.0015
   -0.0012
   -0.0006
   -0.0000
    0.0005
    0.0008
];

%-----------------------------------------------------------
FilterOutput_Up_Analogue = conv(FAnalogue,txUpSample);
FilterOutput_Rect_Analogue = conv(FAnalogue,FilterRecOutput);
%-----------------------------------------------------------

n = length(FilterOutput_Up_Analogue);
t = (0:n-1)/Fs;
freq_res = Fs/n;
f = freq_res*(0:n-1);

N = length(FilterOutput_Rect_Analogue);
T = (0:N-1)/Fs;
freq_resUp = Fs/N;
F = freq_resUp*(0:N-1);

figure
subplot(2,1,1); plot(t,real(FilterOutput_Up_Analogue))
axis([0 20 min(real(FilterOutput_Up_Analogue)) max(real(FilterOutput_Up_Analogue))])
title('Time Domain Filtered Output (pulse Shaping)');

subplot(2,1,2); plot(T,real(FilterOutput_Rect_Analogue))
axis([0 20 min(real(FilterOutput_Rect_Analogue)) max(real(FilterOutput_Rect_Analogue))])
title('Time Domain Filtered Output + Analogue Filter');
pause

figure
subplot(2,1,1); plot(f,10*log10(abs(fft(FilterOutput_Up_Analogue))))
% axis([0 20 -1 1])
title('Frequency Domain Filtered Output');

subplot(2,1,2); plot(F,10*log10(abs(fft(FilterOutput_Rect_Analogue))))
% axis([0 20 -1 1])
title('Frequency Domain Filtered Output + Analogue Filter');
pause

val = 65;

[eyeDZeroPad] = eyeDiagram( val , FilterOutput_Up_Analogue );
[eyeDRect] = eyeDiagram( val , FilterOutput_Rect_Analogue );

figure
subplot(2,1,1); plot(eyeDZeroPad,'b')
title('Eye Diagram Zero Padded');
subplot(2,1,2); plot(eyeDRect,'b')
title('Eye Diagram Rect Filtered Signal');
pause

% ------------------------------------------
FilterOutput = conv(Filter,txUpSample);
FilterOutput2 = conv(FAnalogue,FilterOutput);
%-------------------------------------------

n = length(FilterOutput);
t = (0:n-1)/Fs;
freq_res = Fs/n;
f = freq_res*(0:n-1);
Bandwidth = f(end);

N = length(FilterOutput2);
T = (0:N-1)/Fs;
freq_resUp = Fs/N;
F = freq_resUp*(0:N-1);
BandwidthUpSample = F(end);

figure
subplot(2,1,1); plot(t,real(FilterOutput))
axis([0 20 min(real(FilterOutput)) max(real(FilterOutput))])
title('Time Domain Filtered Output (pulse Shaping)');

subplot(2,1,2); plot(T,real(FilterOutput2))
axis([0 20 min(real(FilterOutput2)) max(real(FilterOutput2))])
title('Time Domain Filtered Output + Analogue Filter');
pause

figure
subplot(2,1,1); plot(f,10*log10(abs(fft(FilterOutput))))
% axis([0 20 -1 1])
title('Frequency Domain Filtered Output');

subplot(2,1,2); plot(F,10*log10(abs(fft(FilterOutput2))))
% axis([0 20 -1 1])
title('Frequency Domain Filtered Output + Analogue Filter');

[eyeDFilterOutput] = eyeDiagram( val , FilterOutput );
[eyeDFilterOutput2] = eyeDiagram( val , FilterOutput2 );

figure
subplot(2,1,1); plot(eyeDFilterOutput,'b')
title('Eye Diagram Zero Padded');
subplot(2,1,2); plot(eyeDFilterOutput2,'b')
title('Eye Diagram Rect Filtered Signal');


[ FilterRRC ] = RootRaiseCosine( 0.22, Fs );
FilterOutputRRC = conv(FilterRRC,txUpSample);

N = length(FilterOutputRRC);
T = (0:N-1)/Fs;
freq_resUp = Fs/N;
F = freq_resUp*(0:N-1);
BandwidthUpSample = F(end);

figure
subplot(3,1,1); plot(T,real(FilterOutputRRC))
title('Time Domain RRC Filtered Signal');
subplot(3,1,2); plot(F,10*log10(abs(fft(FilterOutputRRC))))
title('Frequency Domain Filtered Signal');

[eyeDRRC1] = eyeDiagram( val , FilterOutputRRC );
subplot(3,1,3); plot(eyeDRRC1,'b')
title('Eye Diagram RRC Filtered Signal');
pause

FilterOutputRRC2 = conv(FilterRRC,FilterOutputRRC);

figure
subplot(3,1,1); plot(T,real(FilterOutputRRC2))
title('Time Domain RRC Filtered Signal');
subplot(3,1,2); plot(F,10*log10(abs(fft(FilterOutputRRC2))))
title('Frequency Domain Filtered Signal');
[eyeDRRC2] = eyeDiagram( 2*val , FilterOutputRRC2 );
subplot(3,1,3); plot(eyeDRRC2,'b')
title('Eye Diagram RRC Filtered Signal');