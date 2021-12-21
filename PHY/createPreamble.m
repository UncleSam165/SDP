function Preamble = createPreamble()
    window = [0.5; ones(159,1); 0.5];
    ShortSymbol = sqrt(13/6) * [0,0,0,0,0,0,0, 0, 1+1j, 0, 0, 0, -1-1j, 0, 0, 0, 1+1j, 0, 0, 0, -1-1j, 0, 0, 0, -1-1j, 0, 0, 0, 1+1j, 0, 0, 0, 0,...
                    0, 0, 0, -1-1j, 0, 0, 0, -1-1j, 0, 0, 0, 1+1j, 0, 0, 0, 1+1j, 0, 0, 0, 1+1j, 0, 0, 0, 1+1j, 0,0,0,0,0,0,0].';

    ShortPreamble = ofdmmod(ShortSymbol(ShortSymbol~=0),64,0, ...
        find(ShortSymbol == 0));
    ShortPreamble = [ShortPreamble;ShortPreamble;ShortPreamble(1:(160-128+1))];
    
    ShortPreamble = ShortPreamble .* window;
    
    LongSymbol = [1, 1, -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1,...
                  1, -1, 1, -1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1,...
                  -1, -1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1].';
    LongPreamble = [ofdmmod(LongSymbol, 64, 32,  [1:6 33 64-4:64].');ofdmmod(LongSymbol, 64, 0,  [1:6 33 64-4:64].')];
    LongPreamble = window .* [LongPreamble;LongPreamble(33)];
    
    Preamble = [ShortPreamble(1:end-1); ShortPreamble(end)+LongPreamble(1); LongPreamble(2:end)];
end
