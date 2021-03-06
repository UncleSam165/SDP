function Databits = Demodulation(waveform, rate, length, offset)
%DEMODULATION Summary of this function goes here
%   Detailed explanation goes here
waveform = reshape(waveform, 80, []);
RateTable = containers.Map({3, 4.5, 6, 9, 12, 18, 24, 27}, ...
    {["bpsk" "1/2"], ["bpsk" "3/4"], ["qpsk" "1/2"], ["qpsk" "3/4"], ...
    ["16qam" "1/2"], ["16qam" "3/4"], ["64qam" "2/3"], ["64qam" "3/4"]});
ModScheme = RateTable(rate);
switch ModScheme(1)
    case 'bpsk'
        Demapper = comm.BPSKDemodulator(pi, ...
            'BitOutput', true, ...
            'DecisionMethod','Log-likelihood ratio', ...
             'OutputDataType', int8);
        bits = uint8(zeros());
    case 'qpsk'
        Demapper = comm.PSKDemodulator(4, pi/4, ...
            'BitOutput', true, ...
            'DecisionMethod','Log-likelihood ratio', ...
             'OutputDataType', int8);
    case '16qam'
        M = 16;
        constSym = conj(qammod((0:M-1),M,'UnitAveragePower',true));
        Demapper = comm.GeneralQAMDemodulator(constSym, ...
            'BitOutput', true);
    case '64qam'
        M = 64;
        constSym = conj(qammod((0:M-1),M,'UnitAveragePower',true));
        Demapper = comm.GeneralQAMDemodulator(constSym, ...
            'BitOutput', true, ...
            'DecisionMethod','Log-likelihood ratio', ...
             'OutputDataType', int8);
end

[complexSymbols, pilots] = ofdmdemod(waveform,64,16,offset,[1:6 33 60:64].',[12 26 41 54].');
complexSymbols = reshape(complexSymbols,[],1);

Databits = Demapper(complexSymbols);
% Databits = Databits -1;
% Databits(Databits==-1) = 1;
%Databits = Databits(1:length*8);
end

