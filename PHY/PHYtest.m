clc; clear; close all;
Message = ['Joy, bright spark of divinity,' newline 'Daughter of Elysium,' newline 'Fire-insired we trea'];
MPDU = ['04';'02';'00';'2E';'00';'60';'08';'CD';'37';'A6';'00';'20';'D6';...
    '01';'3C';'F1';'00';'60';'08';'AD';'3B';'AF';'00';'00';...
    dec2hex(Message);'67';'33';'21';'B6'];
Data = MPDU;
Data1 = uint8(bin2dec(reshape(dec2bin(hex2dec(Data)).',[],1)));
pre = createPreamble();
sig = createSignal(18,100);
PreScrData = prepare4Scrambling(Data1,144);
Scrambler = comm.Scrambler(2,'1 + z^4 + z^7',[1 0 1 1 1 0 1],'ResetInputPort',true);
ScrData = Scrambler(PreScrData,1);
EncodedData1 = convenc(ScrData,poly2trellis(7,[133 171]),[1 1 1 0 0 1]);
EncodedData = Interleaver(reshape(EncodedData1,192,[]),192);
MappedData = sqrt(1/10).*   conj(qammod(bin2dec(num2str(reshape(EncodedData,4,[]).')),16));
MappedData = reshape(MappedData,48,[]);
Piloted = zeros(52,size(MappedData,2));
for i = 1:size(MappedData,2)
    Piloted(:,i) = insertPilots(MappedData(:,i),i);
end
T = ofdmmod(Piloted,64,16,[1:6 33 60:64].');

waveform = [pre;sig;T];
%%
[rate, length] = decodeSignal(sig,0);
Databits = Demodulation(T, rate, length, 0);
Deinterleved = Deinterleaver(reshape(Databits,192,[]),192);
Deinterleved = reshape(Deinterleved,[],1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Viterbi Decoder %%%%%%%%%%%%%%%%%%%%%%%%%
trelli = poly2trellis(7,[133 171]);
ConstraintLength = log2(trelli.numStates) + 1;
coderate = 3/4;
tbdepth = 10*(ConstraintLength - 1);
DecodedData = vitdec(Deinterleved, trelli, tbdepth, 'trunc', 'hard',[1 1 1 0 0 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Descrambler %%%%%%%%%%%%%%%%%%%%%%%%%%%
Descrambler = comm.Descrambler(2,'1 + z^4 + z^7',[1 0 1 1 1 0 1],'ResetInputPort',true);
Descrambled = Descrambler(DecodedData,1);
Descrambled = num2str(Descrambled);

MPSU = dec2hex(bin2dec(reshape(Descrambled,8,[])'),2);
MPSU = MPSU(3:2+length,:);



