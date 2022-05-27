function out = prepare4Scrambling(Data,rate)
    RateTable = containers.Map({3, 4.5, 6, 9, 12, 18, 24, 27}, ...
    {24, 36, 48, 72, 96, 144, 192, 216});
    N_DBPS = RateTable(rate);
    Data = [zeros(16,1);Data;zeros(6,1)];
    Padding = (ceil(length(Data)/N_DBPS)*N_DBPS) - length(Data);
    out = [Data;zeros(Padding,1)];
end