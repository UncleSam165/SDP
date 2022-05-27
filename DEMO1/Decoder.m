function DecodedData = Decoder(data, rate)
%DECODER Summary of this function goes here
%   Detailed explanation goes here
RateTable = containers.Map({3, 4.5, 6, 9, 12, 18, 24, 27}, ...
    {["bpsk" "1/2"], ["bpsk" "3/4"], ["qpsk" "1/2"], ["qpsk" "3/4"], ...
    ["16qam" "1/2"], ["16qam" "3/4"], ["64qam" "2/3"], ["64qam" "3/4"]});
coderate = RateTable(rate);
trelli = poly2trellis(7,[133 171]);
ConstraintLength = log2(trelli.numStates) + 1;
tbdepth = 10*(ConstraintLength - 1);
switch coderate(2)
    case "1/2"
        DecodedData = vitdec(data, trelli, tbdepth, 'trunc', 'hard');
    case "3/4"
        puncpat = [1 1 1 0 0 1]';
        DecodedData = vitdec(data, trelli, tbdepth, 'trunc', 'hard', puncpat);
    case "2/3"
        puncpat = [1 1 1 0]';
        DecodedData = vitdec(data, trelli, tbdepth, 'trunc', 'hard', puncpat);
end
end

