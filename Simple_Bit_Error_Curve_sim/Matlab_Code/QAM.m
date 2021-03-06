% For 16 QAM system
% -----------------
clear all
close all

% System configuration
% ------------
b = 4;                              % Distance between bits
M = 2^b;
k = log2(M);                        % Bits per symbol
N = 1e4;                            % Number of symbols in simulation
Nsample = 1;                        % Oversampling rate
A = 1;                              % Amplitude
Es = ((2*(M-1))/3)*A^2;             % Energy per symbol
Eb = Es / k;                        % Energy per bit
EbNo_dB(:,1) = linspace(0, 10, 11); % Energy per bit to noise power spectral density ratio (Eb/No)
SNR_dB(:,1) = EbNo_dB + 10*log10(k) - 10*log10(Nsample);
EbNo_lin(:,1) = 10.^(EbNo_dB / 10); % Eb/No values in linear scale

% Define Arrays
% ------------
diffInxArray = zeros(length(EbNo_lin),N);
diffMinArray = zeros(length(EbNo_lin),N);
rxIdx = zeros(length(EbNo_lin),N);
rxSymbAssignment = zeros(length(EbNo_lin),N);
rxBits  = zeros(k,N);
bit_err = zeros(length(EbNo_lin),1);
diffCellArray = cell(length(EbNo_lin),1);
meanrxSymb = zeros(length(EbNo_lin),1);
meanAWGN = zeros(length(EbNo_lin),1);
meansymbArray = zeros(length(EbNo_lin),1);
meantxSymb = zeros(length(EbNo_lin),1);
meanNoise  = zeros(length(EbNo_lin),1);

% Symbol definition
% ------------
symbArray =[-3+3i,-3+1i,-3-3i,-3-1i,-1+3i,-1+1i,-1-3i,-1-1i,3+3i,3+1i,3-3i,3-1i,1+3i,1+1i,1-3i,1-1i];
symbArrayNorm = mean(abs(symbArray).^2);
Esymb = symbArray./sqrt(symbArrayNorm);
% Define AWGN normalised
% ----------------------
AWGN = ((randn(length(EbNo_lin),N))+1i*(randn(length(EbNo_lin),N)))/sqrt(2);

% Random Data (binary to decimal)
% -------------------------------
txBits = reshape((rand(N*k,1) > 0.5),k,[]);                             % Random bit array for transmittion
txIdx = Bi2Dec(txBits,k);    % Convert bits to Decimal

% Cordinates
% ----------
x = real(symbArray);
y = imag(symbArray);

% Modulation
% ------------
txSymb = symbArray(txIdx+1);     % From look up table determine symbol to be transmitted
Noise = repmat((sqrt(Eb./(EbNo_lin))),1,N) .* AWGN;

% Transmitt over Medium
% ------------
rxSymb = repmat(txSymb,length(EbNo_lin),1) + Noise;

% Demodulation
% ------------
% Euclidean distance between recieved signal and symbol array
% Minimum Euclidean distance and associated index

for i = 1:length(EbNo_lin)
    diffAll = zeros(M,N);
    for ii = 1:N
        % Euclidean distance between recieved signal and symbol array
        diffAll(:,ii) = reshape(abs(symbArray-rxSymb(i,ii)).^2,length(symbArray),[]);
        [minDiff,diffIdx] = min(diffAll(:,ii));
        diffInxArray(i,ii) = diffIdx-1;
        rxSymbAssignment(i,ii) = symbArray(diffInxArray(i,ii)+1);     % From look up table determine symbol to be transmitted
        biStream = Dec2Bi( diffInxArray(i,ii), k );
        rxBits(:,ii) = reshape(biStream',k,[]);
%         diffMinArray(i,ii) = minDiff;
    end
%     diffCellArray{i} = diffAll;
    bit_err(i,1) = sum(rxBits(:) ~= txBits(:));
end

%rxBits = Dec2Bi( diffInxArray, k );     % Convert back to Binary

% for ii = 1:length(EbNo_lin)
%     rxIdx(ii,:) = 8*rxBits{ii}(1,:) + 4*rxBits{ii}(2,:) + 2*rxBits{ii}(3,:) + rxBits{ii}(4,:);    % Convert back to Decimal
%     bit_err(ii,:) = sum(rxBits{ii}(:) ~= txBits(:));
% end

% Bit Error
% --------------------
bit_err = bit_err / (k * N);
bit_err_theo(:,1) = (1/k)*(3/2)*erfc(sqrt((k/10)*EbNo_lin));

% Symbol Error
% --------------------
symb_err = sum(rxIdx(1,:) ~= txIdx(1,:));
symb_err = symb_err / (k * N);

% Check Results
% ------------
for i = 1:length(EbNo_lin)
    meantxSymb(i,1) = mean(abs(txSymb).^2);
    meanrxSymb(i,1) = mean(abs(rxSymb(i,1:N)).^2);
    meanAWGN(i,1) = mean(abs(AWGN(i,1:N)).^2);
    meansymbArray(i,1) = mean(abs(symbArray).^2);
    meanNoise(i,1) = mean(abs(Noise(i,1:N)).^2);
end
test = 10*log10(abs((Es./rxSymb)./Noise));

% Plot Results
% ------------
figure(1)
semilogy(EbNo_dB,bit_err_theo,'b.-');
hold on
semilogy(EbNo_dB,bit_err,'mx-');
grid on

legend('Theory', 'Simulation');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('Bit error probability curve for 16-QAM modulation');

figure(2)
semilogy(SNR_dB,bit_err_theo,'b.-');
hold on
semilogy(SNR_dB,bit_err,'mx-');
grid on

legend('Theory', 'Simulation');
xlabel('SNR, dB');
ylabel('Bit Error Rate');
title('Bit error vs SNR probability curve for 16-QAM modulation');