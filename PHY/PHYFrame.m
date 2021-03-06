function Preamble = creatPreamble()
    ShortSymbol = sqrt(13/6) * [0, 0, 1+1j, 0, 0, 0, -1-1j, 0, 0, 0, 1+1j, 0, 0, 0, -1-1j, 0, 0, 0, -1-1j, 0, 0, 0, 1+1j, 0, 0, 0, 0,...
                    0, 0, 0, -1-1j, 0, 0, 0, -1-1j, 0, 0, 0, 1+1j, 0, 0, 0, 1+1j, 0, 0, 0, 1+1j, 0, 0, 0, 1+1j, 0,0];
    ShortPreamble = [ShortSymbol, ShortSymbol, ShortSymbol, ShortSymbol, ShortSymbol,...
                     ShortSymbol, ShortSymbol, ShortSymbol, ShortSymbol, ShortSymbol,];
    LongSymbol = [1, 1, -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1,...
                  1, -1, 1, 1, 1, 1, 0, 1, -1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1,...
                  -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1];
    LongPreamble = [LongSymbol,LongSymbol];
    Preamble = [ShortPreamble, LongPreamble];
end
