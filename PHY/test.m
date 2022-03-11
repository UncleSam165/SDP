clc; clear; close all;
Message = ['Joy, bright spark of divinity,' newline 'Daughter of Elysium,' newline 'Fire-insired we trea'];
Data = ['04';'02';'00';'2E';'00';'60';'08';'CD';'37';'A6';'00';'20';'D6';...
    '01';'3C';'F1';'00';'60';'08';'AD';'3B';'AF';'00';'00';...
    dec2hex(Message);'67';'33';'21';'B6'];
Data = uint8(bin2dec(reshape(dec2bin(hex2dec(Data)).',[],1)));
pre = createPreamble();
sig = createSignal(18,100);
PreScrData = prepare4Scrambling(Data,144);
Scrambler = comm.Scrambler(2,'1 + z^4 + z^7',[1 0 1 1 1 0 1],'ResetInputPort',true);
ScrData = Scrambler(PreScrData,1);
EncodedData = convenc(ScrData,poly2trellis(7,[133 171]),[1 1 1 0 0 1]);
EncodedData = Interleaver(reshape(EncodedData,192,[]),192);
MappedData = sqrt(1/10).*   conj(qammod(bin2dec(num2str(reshape(EncodedData,4,[]).')),16));
MappedData = reshape(MappedData,48,[]);
Piloted = zeros(52,size(MappedData,2));
for i = 1:size(MappedData,2)
    Piloted(:,i) = insertPilots(MappedData(:,i),i);
end
T = ofdmmod(Piloted,64,16,[1:6 33 60:64].');

waveform = [pre;sig;T];
figure
t = linspace(0,floor(length(waveform)/80),length(waveform));
subplot(2,1,1)
plot(t, real(waveform))
title('Real Part of the OFDM waveform')
subplot(2,1,2)
plot(t, imag(waveform))
title('Imaginary Part of the OFDM waveform')

%% Receiver
% [preamble, Data] = extractPreamble()

[rate, length] = decodeSignal(sig,0);
Databits = Demodulation(T, rate, length, 0);
Databits == reshape(EncodedData,[],1);
sum(Databits == reshape(EncodedData,[],1))
