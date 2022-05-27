function IQ = Mapper(Input, rate)
%MAPPER Summary of this function goes here
%   Detailed explanation goes here
RateTable = containers.Map({3, 4.5, 6, 9, 12, 18, 24, 27}, ...
    {["bpsk" "1/2"], ["bpsk" "3/4"], ["qpsk" "1/2"], ["qpsk" "3/4"], ...
    ["16qam" "1/2"], ["16qam" "3/4"], ["64qam" "2/3"], ["64qam" "3/4"]});
ModScheme = RateTable(rate);
switch ModScheme(1)
    case 'bpsk'
        Mapper = comm.BPSKModulator(pi);
        bits = bin2dec(num2str(reshape(Input,1,[]).'));
    case 'qpsk'
        Mapper = comm.PSKModulator(4,...
            pi/4,...
            'SymbolMapping', 'Custom',...
            'CustomSymbolMapping', [3,1,0,2]);
        bits = bin2dec(num2str(reshape(Input,2,[]).'));
    case '16qam'
        M = 16;
        constSym = conj(qammod((0:M-1),M,'UnitAveragePower',true));
        Mapper = comm.GeneralQAMModulator(constSym);
        bits = bin2dec(num2str(reshape(Input,4,[]).'));
    case '64qam'
        M = 64;
        constSym = conj(qammod((0:M-1),M,'UnitAveragePower',true));
        Mapper = comm.GeneralQAMModulator(constSym);
        bits = bin2dec(num2str(reshape(Input,6,[]).'));
end
IQ = Mapper(bits);
end

