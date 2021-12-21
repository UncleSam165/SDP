function Signal = createSignal(Rate,Length)
    Tail = uint8(zeros(6,1));
    window = [0.5; ones(78,1); 0.5];
    RateTable = containers.Map({3, 4.5, 6, 9, 12, 18, 24, 27},...
               {uint8([1 1 0 1]), uint8([1 1 1 1]), uint8([0 1 0 1]),...
               uint8([0 1 1 1]), uint8([1 0 0 1]), uint8([1 0 1 1]),...
               uint8([0 0 0 1]), uint8([0 0 1 1])});
    RateBits = RateTable(Rate).';
    LengthBits = uint8(flipud(int2bit(Length,12)));
    ParityBit = uint8(mod(sum([RateBits;0;LengthBits]),2));
    SignalBits = [RateBits;0;LengthBits;ParityBit;Tail];
    SignalBits = convenc(SignalBits,poly2trellis(7,[133 171]));
    SignalBits = Interleaver(SignalBits,48);
    Signal = pskmod(SignalBits,2,pi);
    Signal = insertPilots(Signal,0);
    Signal = window .* ofdmmod(Signal,64,16,[1:6 33 60:64].');
end