function [rate, length, ChanEstimate] = decodeSignal(SignalWaveform, Offset, ChanEstimate,SNR)
%DECODESIGNAL Extract RATE and LENGTH from Signal OFDM symbol of the IEEE 802.11 PPDU
%   This functon takes Signal OFDM symbol with certain Offset, performs the OFDM demodulation
%   and returns the RATE and LENGTH specified in the Symbol.

[Sig, RcvPilots] = ofdmdemod(SignalWaveform, 64, 16, Offset, [1:6 33 60:64].',[12 26 40 54].');
[ ~, Pilots] = insertPilots([],0);
RcvPilots = RcvPilots./Pilots;
ChanEstimate = UpdateChanEstimate(ChanEstimate, RcvPilots, 12);
Sig = Equalize(Sig,ChanEstimate,SNR);
bits = pskdemod(Sig, 2, pi);
RateTable = containers.Map({'1101', '1111', '0101', '0111', '1001', '1011', '0001', '0011'},...
    {3, 4.5, 6, 9, 12, 18, 24, 27});
bits = Deinterleaver(bits, 3);
bits = vitdec(bits, poly2trellis(7,[133 171]),1,'trunc', 'hard');
rate = "";
for i = bits(1:4)'
    rate = rate + string(i);
end

try
rate = RateTable(rate);
length = bit2int(flipud(bits(6:6+11)), 12);
catch
rate = -1;
length = -1;
end
end

