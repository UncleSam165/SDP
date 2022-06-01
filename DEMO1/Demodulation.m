function Databits = Demodulation(waveform, rate, Length, offset, ChanEstimate, SNR)
%DEMODULATION Summary of this function goes here
%   Detailed explanation goes here
waveform = reshape(waveform, 80, []);
RateTable = containers.Map({3, 4.5, 6, 9, 12, 18, 24, 27}, ...
    {["bpsk" "1/2"], ["bpsk" "3/4"], ["qpsk" "1/2"], ["qpsk" "3/4"], ...
    ["16qam" "1/2"], ["16qam" "3/4"], ["64qam" "2/3"], ["64qam" "3/4"]});
ModScheme = RateTable(rate);
switch ModScheme(1)
    case 'bpsk'
        Demapper = comm.BPSKDemodulator(pi);
    case 'qpsk'
        Demapper = comm.PSKDemodulator(4, pi/4, ...
            'SymbolMapping',"Custom",...
            'CustomSymbolMapping',[3,1,0,2],...
            'BitOutput', true);
    case '16qam'
        M = 16;
        constSym = conj(qammod((0:M-1),M,'UnitAveragePower',true));
        Demapper = comm.GeneralQAMDemodulator(constSym, ...
            'BitOutput', true);
    case '64qam'
        M = 64;
        constSym = conj(qammod((0:M-1),M,'UnitAveragePower',true));
        Demapper = comm.GeneralQAMDemodulator(constSym, ...
            'BitOutput', true);
end

[complexSymbols, RcvPilots] = ofdmdemod(waveform,64,16,offset,[1:6 33 60:64].',[12 26 41 54].');
[r,~,z] = size(complexSymbols);
ComplexSymbols = zeros(r*z,1);
for i = 1:z
    [~, pilots] = insertPilots([],i);
    pilotEst = RcvPilots(:,1,i)./pilots;
    ChanEstimate = UpdateChanEstimate(ChanEstimate,pilotEst,12);
    out = Equalize(complexSymbols(:,1,i),ChanEstimate,SNR);
    ComplexSymbols((i-1)*48+1:i*48) = out;
end


Databits = Demapper(ComplexSymbols);
% Databits = Databits -1;
% Databits(Databits==-1) = 1;
%Databits = Databits(1:length*8);
end

