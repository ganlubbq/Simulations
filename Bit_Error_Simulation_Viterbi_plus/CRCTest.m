close all
clear all

numberofPacketsArray =[4*(2^8) 4*(2^16) 4*(2^24) 4*(2^24)];%4*(2^24);
ParityArray = {'gCRC8', 'gCRC16', 'gCRC24B', 'gCRC24A'};
NumParity = length(ParityArray);
BitErrorsArray = 1:10; 
NumBitError = length(BitErrorsArray);
crcErrorSumTotal = zeros(NumBitError,NumParity);

for i = 1:NumParity
    crcErrorSum = zeros(NumBitError,1); 
    numberofPackets = numberofPacketsArray(i);
    PacketSizeArray =zeros(numberofPackets,NumBitError);
    for j = 1:NumBitError
        BitErrorsAdded = BitErrorsArray(j);
        Parity = ParityArray{i};
        crcErrorTotal = zeros(numberofPackets,1); 
        for ii = 1:numberofPackets
            [NewPacketSize]  = randi([2^5 2^10],1);
            PacketSizeArray(ii,j) = NewPacketSize;
            [TxPacket] = double(rand(1,NewPacketSize) > 0.5);
            [TxPacket, TxPacketLength] = GetCRC('Transmitter', TxPacket, Parity);
                randArray = randperm(TxPacketLength);
                RxMessage = TxPacket;
                for k = 1:BitErrorsAdded
                   if RxMessage(randArray(k)) ==0 
                       RxMessage(randArray(k)) =1;
                   else
                       RxMessage(randArray(k)) = 0;
                   end
                end
            [ DecodedMessage, crcError ] = GetCRC('Reciever', RxMessage, Parity);
            crcErrorTotal(ii) = crcError;
        end
        crcErrorSum(j) = sum(crcErrorTotal);
    end
    crcErrorSumTotal(:,i)= crcErrorSum;
   
end
figure(1)
    hold on
    semilogy( BitErrorsArray, 1-(crcErrorSumTotal./numberofPackets),':');

    xlabel('Bit Errors');
    ylabel('Packet Failure');
    
legend('gCRC8', 'gCRC16', 'gCRC24B', 'gCRC24A');
hold off