close all

[ h ] = RootRaiseCosine( 0.5, 12, 8 );
h=conv(h,h);
figure
plot(h)
figure
plot(20*log10(fftshift(abs(fft(h,256)))))
figure
plot(h(1:8:end))
