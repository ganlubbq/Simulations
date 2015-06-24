close all
clear all
M = 4;
[ k, Es, Esnorm, Eb, Ebnorm, SymbArray_QPSK ] = GetSymbolArrayData( M );
newarray1 = SymbArray_QPSK(1)+SymbArray_QPSK.';
newarray2 = SymbArray_QPSK(2)+SymbArray_QPSK.';
newarray3 = SymbArray_QPSK(3)+SymbArray_QPSK.';
newarray4 = SymbArray_QPSK(4)+SymbArray_QPSK.';
NewArray = [newarray1; newarray2; newarray3; newarray4];
Nsubcarriers = 300;
TxPacket = double(rand(1,Nsubcarriers*k) > 0.5);
[ TxSymbolIdx, TrCHFrameSize ] = SymbolIndex( TxPacket, k );
[ TxSymbol ] = SymbArray_QPSK(TxSymbolIdx); 
count = 1;
for i = 1:length(TxSymbol)
    for ii = 1:4
        temp(count) = TxSymbol(i)+SymbArray_QPSK(ii);
        count = count+1;
    end
end
figure
plot(temp,'rp')
set(gca, 'FontSize',14);  
xlabel('I')
ylabel('Q')
title('QPSK Symbols')

grid on
peakQpsk = max(abs(NewArray).^2);
idx = find(abs(temp).^2==peakQpsk);
prob = length(idx)/length(temp);
meanQpsk = mean(abs(NewArray).^2);
papr = peakQpsk./meanQpsk;
